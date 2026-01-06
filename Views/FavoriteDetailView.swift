//
//  FavoriteDetailView.swift
//  FavoriteDetailView
//
//  Created by Oliwia Kołacz on 06/01/2026.
//

import SwiftUI

struct FavoriteDetailView: View {
    let favorite: FavoriteEvent
    @ObservedObject var favoritesViewModel: FavoritesViewModel
    
    @Environment(\.openURL) private var openURL
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero Image
                AsyncImage(url: URL(string: favorite.imageURL ?? "")) { phase in
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
                        Text(favorite.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button {
                            favoritesViewModel.removeFromFavorites(favorite)
                            dismiss()
                        } label: {
                            Image(systemName: "heart.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Kategoria
                    if let category = favorite.category {
                        Text(category)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .clipShape(Capsule())
                    }
                    
                    // Info Cards
                    VStack(spacing: 12) {
                        // Data
                        InfoCard(
                            icon: "calendar",
                            title: "Data i godzina",
                            value: favorite.formattedDate
                        )
                        
                        // Miejsce
                        InfoCard(
                            icon: "mappin.circle.fill",
                            title: "Miejsce",
                            value: favorite.venueInfo
                        )
                        
                        // Cena
                        if let price = favorite.priceInfo {
                            InfoCard(
                                icon: "creditcard.fill",
                                title: "Cena",
                                value: price
                            )
                        }
                    }
                    
                    Spacer(minLength: 20)
                    
                    // Przycisk kup bilet
                    if let urlString = favorite.ticketURL, let url = URL(string: urlString) {
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
