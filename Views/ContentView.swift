//
//  ContentView.swift
//  CityEvents
//
//  Created by Oliwia Kołacz on 06/01/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var eventsViewModel = EventsViewModel()
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    
    var body: some View {
        TabView {
            HomeView(
                eventsViewModel: eventsViewModel,
                favoritesViewModel: favoritesViewModel
            )
            .tabItem {
                Label("Wydarzenia", systemImage: "calendar")
            }
            
            FavoritesView(favoritesViewModel: favoritesViewModel)
                .tabItem {
                    Label("Ulubione", systemImage: "heart.fill")
                }
            
            AboutView()
                .tabItem {
                    Label("O Aplikacji", systemImage: "info.circle")
                }
        }
        .onAppear {
            favoritesViewModel.setModelContext(modelContext)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: FavoriteEvent.self, inMemory: true)
}

