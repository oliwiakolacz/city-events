//
//  EventCategory.swift
//  CityEvents
//
//  Created by Oliwia Kołacz on 06/01/2026.
//

import Foundation

enum EventCategory: String, CaseIterable, Identifiable {
    case all = ""
    case music = "music"
    case sports = "sports"
    case arts = "arts"
    case film = "film"
    case miscellaneous = "miscellaneous"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .all: return "Wszystkie"
        case .music: return "Muzyka"
        case .sports: return "Sport"
        case .arts: return "Sztuka"
        case .film: return "Film"
        case .miscellaneous: return "Inne"
        }
    }
    
    var icon: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .music: return "music.note"
        case .sports: return "sportscourt"
        case .arts: return "theatermasks"
        case .film: return "film"
        case .miscellaneous: return "star"
        }
    }
}
