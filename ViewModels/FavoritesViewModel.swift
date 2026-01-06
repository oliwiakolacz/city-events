//
//
//  FavoritesViewModel.swift
//  CityEvents
//
//  Created by Oliwia Kołacz on 06/01/2026.
//

import Foundation
import SwiftUI
import SwiftData
import Combine

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favorites: [FavoriteEvent] = []
    
    private var modelContext: ModelContext?
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        fetchFavorites()
    }
    
    func fetchFavorites() {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<FavoriteEvent>(
            sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]
        )
        
        do {
            favorites = try context.fetch(descriptor)
        } catch {
            print("Error fetching favorites: \(error)")
            favorites = []
        }
    }
    
    func addToFavorites(_ event: Event) {
        guard let context = modelContext else { return }
        
        // Sprawdź czy już istnieje
        guard !isFavorite(event) else { return }
        
        let favorite = FavoriteEvent(from: event)
        context.insert(favorite)
        
        do {
            try context.save()
            fetchFavorites()
        } catch {
            print("Error saving favorite: \(error)")
        }
    }
    
    func removeFromFavorites(_ event: Event) {
        guard let context = modelContext else { return }
        
        let eventId = event.id
        let descriptor = FetchDescriptor<FavoriteEvent>(
            predicate: #Predicate { $0.id == eventId }
        )
        
        do {
            let results = try context.fetch(descriptor)
            for favorite in results {
                context.delete(favorite)
            }
            try context.save()
            fetchFavorites()
        } catch {
            print("Error removing favorite: \(error)")
        }
    }
    
    func removeFromFavorites(_ favorite: FavoriteEvent) {
        guard let context = modelContext else { return }
        
        context.delete(favorite)
        
        do {
            try context.save()
            fetchFavorites()
        } catch {
            print("Error removing favorite: \(error)")
        }
    }
    
    func isFavorite(_ event: Event) -> Bool {
        favorites.contains { $0.id == event.id }
    }
    
    func toggleFavorite(_ event: Event) {
        if isFavorite(event) {
            removeFromFavorites(event)
        } else {
            addToFavorites(event)
        }
    }
}
