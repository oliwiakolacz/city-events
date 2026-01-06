//
//  FavoritesView.swift
//  FavoritesView
//
//  Created by Oliwia Kołacz on 06/01/2026.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if favoritesViewModel.favorites.isEmpty {
                    emptyView
                } else {
                    List {
                        ForEach(favoritesViewModel.favorites) { favorite in
                            NavigationLink {
                                FavoriteDetailView(
                                    favorite: favorite,
                                    favoritesViewModel: favoritesViewModel
                                )
                            } label: {
                                FavoriteRowView(favorite: favorite)
                            }
                        }
                        .onDelete(perform: deleteFavorites)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Ulubione")
            .toolbar {
                if !favoritesViewModel.favorites.isEmpty {
                    EditButton()
                }
            }
        }
    }
    
    // MARK: - Empty View
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Brak ulubionych")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Dodaj wydarzenia do ulubionych,\naby mieć do nich szybki dostęp")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Delete
    private func deleteFavorites(at offsets: IndexSet) {
        for index in offsets {
            let favorite = favoritesViewModel.favorites[index]
            favoritesViewModel.removeFromFavorites(favorite)
        }
    }
}

// MARK: - Preview
#Preview {
    FavoritesView(favoritesViewModel: FavoritesViewModel())
}
