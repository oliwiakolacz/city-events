//
//  FavoriteEvent.swift
//  FavoriteEvent
//
//  Created by Oliwia Kołacz on 06/01/2026.
//

import Foundation
import SwiftData

@Model
final class FavoriteEvent {
    @Attribute(.unique) var id: String
    var name: String
    var imageURL: String?
    var venueName: String?
    var venueCity: String?
    var localDate: String?
    var localTime: String?
    var priceInfo: String?
    var ticketURL: String?
    var category: String?
    var dateAdded: Date
    
    init(from event: Event) {
        self.id = event.id
        self.name = event.name
        self.imageURL = event.imageURL?.absoluteString
        self.venueName = event.venue?.name
        self.venueCity = event.venue?.city?.name
        self.localDate = event.localDate
        self.localTime = event.localTime
        self.priceInfo = event.priceInfo
        self.ticketURL = event.url
        self.category = event.category
        self.dateAdded = Date()
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
    
    var venueInfo: String {
        var parts: [String] = []
        if let name = venueName {
            parts.append(name)
        }
        if let city = venueCity {
            parts.append(city)
        }
        return parts.isEmpty ? "Miejsce nieznane" : parts.joined(separator: ", ")
    }
}
