//
//
//  EventsViewModel.swift
//  CityEvents
//
//  Created by Oliwia Kołacz on 06/01/2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class EventsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var events: [Event] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasMorePages = true
    
    // MARK: - Filters
    @Published var selectedCity: String = "Warsaw" {
        didSet { Task { await refreshEvents() } }
    }
    
    @Published var selectedCategory: EventCategory = .all {
        didSet { Task { await refreshEvents() } }
    }
    
    @Published var startDate: Date = Date() {
        didSet { Task { await refreshEvents() } }
    }
    
    @Published var endDate: Date? = nil {
        didSet { Task { await refreshEvents() } }
    }
    
    // MARK: - Pagination
    private var currentPage = 0
    private var totalPages = 1
    
    // MARK: - Available Cities
    let availableCities = [
        "Warsaw",
        "Krakow", 
        "Gdansk",
        "Wroclaw",
        "Poznan",
        "Lodz",
        "Katowice",
        "Berlin",
        "Prague",
        "Vienna"
    ]
    
    // MARK: - Network Service
    private let networkService = NetworkService.shared
    
    // MARK: - Public Methods
    func loadEvents() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await networkService.fetchEvents(
                city: selectedCity,
                category: selectedCategory,
                startDate: startDate,
                endDate: endDate,
                page: currentPage
            )
            
            if let newEvents = response.embedded?.events {
                if currentPage == 0 {
                    events = newEvents
                } else {
                    events.append(contentsOf: newEvents)
                }
            } else if currentPage == 0 {
                events = []
            }
            
            if let page = response.page {
                totalPages = page.totalPages
                hasMorePages = page.number < page.totalPages - 1
            }
            
        } catch {
            errorMessage = error.localizedDescription
            if currentPage == 0 {
                events = []
            }
        }
        
        isLoading = false
    }
    
    func refreshEvents() async {
        currentPage = 0
        hasMorePages = true
        await loadEvents()
    }
    
    func loadMoreIfNeeded(currentEvent: Event) async {
        guard let lastEvent = events.last,
              lastEvent.id == currentEvent.id,
              hasMorePages,
              !isLoading else { return }
        
        currentPage += 1
        await loadEvents()
    }
    
    func clearFilters() {
        selectedCategory = .all
        startDate = Date()
        endDate = nil
    }
}
