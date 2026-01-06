//
//  Event.swift
//  Event
//
//  Created by Oliwia Kołacz on 06/01/2026.
//

import Foundation

// MARK: - API Response
struct TicketmasterResponse: Codable {
    let embedded: Embedded?
    let page: Page?
    
    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case page
    }
}

struct Embedded: Codable {
    let events: [Event]
}

struct Page: Codable {
    let totalElements: Int
    let totalPages: Int
    let number: Int
}

// MARK: - Event
struct Event: Codable, Identifiable {
    let id: String
    let name: String
    let url: String?
    let images: [EventImage]?
    let dates: EventDates?
    let priceRanges: [PriceRange]?
    let embedded: EventEmbedded?
    let classifications: [Classification]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, url, images, dates, priceRanges, classifications
        case embedded = "_embedded"
    }
    
    // MARK: - Computed Properties
    var imageURL: URL? {
        guard let urlString = images?.first(where: { $0.ratio == "16_9" })?.url
                ?? images?.first?.url else { return nil }
        return URL(string: urlString)
    }
    
    var venue: Venue? {
        embedded?.venues?.first
    }
    
    var startDate: Date? {
        guard let dateString = dates?.start?.dateTime else { return nil }
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString)
    }
    
    var localDate: String? {
        dates?.start?.localDate
    }
    
    var localTime: String? {
        dates?.start?.localTime
    }
    
    var formattedDate: String {
        guard let localDate = localDate else { return "Data nieznana" }
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = inputFormatter.date(from: localDate) else { return localDate }
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "pl_PL")
        outputFormatter.dateFormat = "d MMMM yyyy"
        
        var result = outputFormatter.string(from: date)
        
        if let time = localTime {
            let timeInput = DateFormatter()
            timeInput.dateFormat = "HH:mm:ss"
            if let timeDate = timeInput.date(from: time) {
                let timeOutput = DateFormatter()
                timeOutput.dateFormat = "HH:mm"
                result += ", \(timeOutput.string(from: timeDate))"
            }
        }
        
        return result
    }
    
    var priceInfo: String {
        guard let price = priceRanges?.first else { return "Cena nieznana" }
        if price.min == price.max {
            return String(format: "%.0f %@", price.min, price.currency)
        }
        return String(format: "%.0f - %.0f %@", price.min, price.max, price.currency)
    }
    
    var category: String {
        classifications?.first?.segment?.name ?? "Inne"
    }
}

// MARK: - Supporting Types
struct EventImage: Codable {
    let url: String
    let ratio: String?
    let width: Int?
    let height: Int?
}

struct EventDates: Codable {
    let start: EventStart?
    let status: EventStatus?
}

struct EventStart: Codable {
    let localDate: String?
    let localTime: String?
    let dateTime: String?
}

struct EventStatus: Codable {
    let code: String?
}

struct PriceRange: Codable {
    let min: Double
    let max: Double
    let currency: String
}

struct EventEmbedded: Codable {
    let venues: [Venue]?
}

struct Venue: Codable {
    let id: String?
    let name: String
    let city: VenueCity?
    let address: VenueAddress?
    let country: VenueCountry?
    
    var fullAddress: String {
        var parts: [String] = []
        if let address = address?.line1 {
            parts.append(address)
        }
        if let city = city?.name {
            parts.append(city)
        }
        if let country = country?.name {
            parts.append(country)
        }
        return parts.isEmpty ? "Adres nieznany" : parts.joined(separator: ", ")
    }
}

struct VenueCity: Codable {
    let name: String
}

struct VenueAddress: Codable {
    let line1: String?
}

struct VenueCountry: Codable {
    let name: String
    let countryCode: String
}

struct Classification: Codable {
    let segment: Segment?
    let genre: Genre?
}

struct Segment: Codable {
    let id: String?
    let name: String?
}

struct Genre: Codable {
    let id: String?
    let name: String?
}
