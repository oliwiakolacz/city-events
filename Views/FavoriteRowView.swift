//
//  FavoriteRowView.swift
//  CityEvents
//
//  Created by Oliwia Kołacz on 06/01/2026.
//

import SwiftUI

struct FavoriteRowView: View {
    let favorite: FavoriteEvent
    
    var body: some View {
        HStack(spacing: 12) {
            // Obrazek
            AsyncImage(url: URL(string: favorite.imageURL ?? "")) { phase in
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
                Text(favorite.name)
                    .font(.headline)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(favorite.formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "mappin")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(favorite.venueInfo)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                HStack {
                    // Kategoria
                    if let category = favorite.category {
                        Text(category)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    // Cena
                    if let price = favorite.priceInfo {
                        Text(price)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.green)
                    }
                }
            }
            
            // Ikona serca
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
                .font(.title3)
        }
        .padding(.vertical, 4)
    }
}
