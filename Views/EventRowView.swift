//
//
//  EventRowView.swift
//  CityEvents
//
//  Created by Oliwia Kołacz on 06/01/2026.
//

import SwiftUI

struct EventRowView: View {
    let event: Event
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Obrazek
            AsyncImage(url: event.imageURL) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .overlay {
                            ProgressView()
                        }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(event.name)
                    .font(.headline)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(event.formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "mappin")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(event.venue?.name ?? "Miejsce nieznane")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                HStack {
                    // Kategoria
                    Text(event.category)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    // Cena
                    Text(event.priceInfo)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                }
            }
            
            // Przycisk ulubione
            Button(action: onFavoriteToggle) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
                    .font(.title3)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
#Preview {
    List {
        EventRowView(
            event: Event.preview,
            isFavorite: false,
            onFavoriteToggle: {}
        )
        EventRowView(
            event: Event.preview,
            isFavorite: true,
            onFavoriteToggle: {}
        )
    }
}

// MARK: - Preview Helper
extension Event {
    static var preview: Event {
        Event(
            id: "1",
            name: "Coldplay - Music of the Spheres World Tour",
            url: "https://ticketmaster.com",
            images: nil,
            dates: EventDates(
                start: EventStart(
                    localDate: "2026-06-15",
                    localTime: "20:00:00",
                    dateTime: nil
                ),
                status: nil
            ),
            priceRanges: [PriceRange(min: 150, max: 450, currency: "PLN")],
            embedded: EventEmbedded(
                venues: [
                    Venue(
                        id: "1",
                        name: "PGE Narodowy",
                        city: VenueCity(name: "Warszawa"),
                        address: VenueAddress(line1: "al. Poniatowskiego 1"),
                        country: VenueCountry(name: "Poland", countryCode: "PL")
                    )
                ]
            ),
            classifications: [
                Classification(
                    segment: Segment(id: "1", name: "Music"),
                    genre: Genre(id: "1", name: "Rock")
                )
            ]
        )
    }
}
