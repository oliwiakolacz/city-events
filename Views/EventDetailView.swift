//
//
//  EventDetailView.swift
//  CityEvents
//
//  Created by Oliwia Kołacz on 06/01/2026.
//

import SwiftUI

struct EventDetailView: View {
    let event: Event
    @ObservedObject var favoritesViewModel: FavoritesViewModel
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                AsyncImage(url: event.imageURL) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .overlay { ProgressView() }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .overlay {
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                            }
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 250)
                .clipped()
                
                VStack(alignment: .leading, spacing: 20) {
                    // Tytuł i ulubione
                    HStack(alignment: .top) {
                        Text(event.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button {
                            favoritesViewModel.toggleFavorite(event)
                        } label: {
                            Image(systemName: favoritesViewModel.isFavorite(event) ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(favoritesViewModel.isFavorite(event) ? .red : .gray)
                        }
                    }
                    
                    // Kategoria
                    Text(event.category)
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .clipShape(Capsule())
                    
                    // Info Cards
                    VStack(spacing: 12) {
                        // Data
                        InfoCard(
                            icon: "calendar",
                            title: "Data i godzina",
                            value: event.formattedDate
                        )
                        
                        // Miejsce
                        InfoCard(
                            icon: "mappin.circle.fill",
                            title: "Miejsce",
                            value: event.venue?.name ?? "Nieznane"
                        )
                        
                        // Adres
                        if let venue = event.venue {
                            InfoCard(
                                icon: "location.fill",
                                title: "Adres",
                                value: venue.fullAddress
                            )
                        }
                        
                        // Cena
                        InfoCard(
                            icon: "creditcard.fill",
                            title: "Cena",
                            value: event.priceInfo
                        )
                    }
                    
                    Spacer(minLength: 20)
                    
                    // Przycisk kup bilet
                    if let urlString = event.url, let url = URL(string: urlString) {
                        Button {
                            openURL(url)
                        } label: {
                            HStack {
                                Image(systemName: "ticket.fill")
                                Text("Kup bilet")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
    }
}

// MARK: - Info Card
struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        EventDetailView(
            event: Event.preview,
            favoritesViewModel: FavoritesViewModel()
        )
    }
}
