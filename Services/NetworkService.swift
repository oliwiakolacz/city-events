//
//  NetworkService.swift
//  NetworkService
//
//  Created by Oliwia Kołacz on 06/01/2026.
//

import Foundation
import Combine

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(Int)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Nieprawidłowy adres URL"
        case .noData:
            return "Brak danych z serwera"
        case .decodingError(let error):
            return "Błąd przetwarzania danych: \(error.localizedDescription)"
        case .serverError(let code):
            return "Błąd serwera: \(code)"
        case .networkError(let error):
            return "Błąd sieci: \(error.localizedDescription)"
        }
    }
}

@MainActor
class NetworkService: ObservableObject {
    static let shared = NetworkService()
    
    // MARK: - Configuration
    private let apiKey = "API_KEY"
    private let baseURL = "https://app.ticketmaster.com/discovery/v2"
    
    private init() {}
    
    // MARK: - Fetch Events
    func fetchEvents(
        city: String,
        category: EventCategory = .all,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int = 0,
        size: Int = 20
    ) async throws -> TicketmasterResponse {
        var components = URLComponents(string: "\(baseURL)/events.json")
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "city", value: city),
            URLQueryItem(name: "size", value: String(size)),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "sort", value: "date,asc")
        ]
        
        // Kategoria
        if category != .all {
            queryItems.append(URLQueryItem(name: "classificationName", value: category.rawValue))
        }
        
        // Zakres dat
        let dateFormatter = ISO8601DateFormatter()
        
        if let start = startDate {
            queryItems.append(URLQueryItem(name: "startDateTime", value: dateFormatter.string(from: start)))
        } else {
            // Domyślnie od dziś
            queryItems.append(URLQueryItem(name: "startDateTime", value: dateFormatter.string(from: Date())))
        }
        
        if let end = endDate {
            queryItems.append(URLQueryItem(name: "endDateTime", value: dateFormatter.string(from: end)))
        }
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        return try await performRequest(url: url)
    }
    
    // MARK: - Fetch Event Details
    func fetchEventDetails(eventId: String) async throws -> Event {
        var components = URLComponents(string: "\(baseURL)/events/\(eventId).json")
        components?.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey)
        ]
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        return try await performRequest(url: url)
    }
    
    // MARK: - Private Methods
    private func performRequest<T: Codable>(url: URL) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.noData
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}
