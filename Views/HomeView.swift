//
//  HomeView.swift
//  CityEvents
//
//  Created by Oliwia Kołacz on 06/01/2026.
//

import SwiftUI
import Combine

struct HomeView: View {
    @ObservedObject var eventsViewModel: EventsViewModel
    @ObservedObject var favoritesViewModel: FavoritesViewModel
    
    @State private var showFilters = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filtry górne
                filterHeader
                
                // Lista wydarzeń
                eventsList
            }
            .navigationTitle("Wydarzenia")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFilters.toggle()
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                FiltersSheet(viewModel: eventsViewModel)
                    .presentationDetents([.medium])
            }
            .task {
                if eventsViewModel.events.isEmpty {
                    await eventsViewModel.loadEvents()
                }
            }
        }
    }
    
    // MARK: - Filter Header
    private var filterHeader: some View {
        VStack(spacing: 12) {
            // Miasto
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.blue)
                
                Picker("Miasto", selection: $eventsViewModel.selectedCity) {
                    ForEach(eventsViewModel.availableCities, id: \.self) { city in
                        Text(city).tag(city)
                    }
                }
                .pickerStyle(.menu)
                
                Spacer()
            }
            .padding(.horizontal)
            
            // Kategorie
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(EventCategory.allCases) { category in
                        CategoryChip(
                            category: category,
                            isSelected: eventsViewModel.selectedCategory == category
                        ) {
                            eventsViewModel.selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Events List
    private var eventsList: some View {
        Group {
            if eventsViewModel.isLoading && eventsViewModel.events.isEmpty {
                ProgressView("Ładowanie wydarzeń...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = eventsViewModel.errorMessage, eventsViewModel.events.isEmpty {
                errorView(error)
            } else if eventsViewModel.events.isEmpty {
                emptyView
            } else {
                List {
                    ForEach(eventsViewModel.events) { event in
                        NavigationLink {
                            EventDetailView(
                                event: event,
                                favoritesViewModel: favoritesViewModel
                            )
                        } label: {
                            EventRowView(
                                event: event,
                                isFavorite: favoritesViewModel.isFavorite(event),
                                onFavoriteToggle: {
                                    favoritesViewModel.toggleFavorite(event)
                                }
                            )
                        }
                        .onAppear {
                            Task {
                                await eventsViewModel.loadMoreIfNeeded(currentEvent: event)
                            }
                        }
                    }
                    
                    if eventsViewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    await eventsViewModel.refreshEvents()
                }
            }
        }
    }
    
    // MARK: - Empty View
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Brak wydarzeń")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Nie znaleziono wydarzeń dla wybranych filtrów")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Wyczyść filtry") {
                eventsViewModel.clearFilters()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Error View
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("Wystąpił błąd")
                .font(.title2)
                .fontWeight(.medium)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Spróbuj ponownie") {
                Task {
                    await eventsViewModel.refreshEvents()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let category: EventCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: category.icon)
                    .font(.caption)
                Text(category.displayName)
                    .font(.subheadline)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color(.systemGray5))
            .foregroundColor(isSelected ? .white : .primary)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Filters Sheet
struct FiltersSheet: View {
    @ObservedObject var viewModel: EventsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Data") {
                    DatePicker(
                        "Od",
                        selection: $viewModel.startDate,
                        displayedComponents: .date
                    )
                    
                    Toggle("Ustaw datę końcową", isOn: Binding(
                        get: { viewModel.endDate != nil },
                        set: { viewModel.endDate = $0 ? Date().addingTimeInterval(7*24*60*60) : nil }
                    ))
                    
                    if viewModel.endDate != nil {
                        DatePicker(
                            "Do",
                            selection: Binding(
                                get: { viewModel.endDate ?? Date() },
                                set: { viewModel.endDate = $0 }
                            ),
                            displayedComponents: .date
                        )
                    }
                }
                
                Section {
                    Button("Wyczyść filtry", role: .destructive) {
                        viewModel.clearFilters()
                    }
                }
            }
            .navigationTitle("Filtry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Gotowe") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView(
        eventsViewModel: EventsViewModel(),
        favoritesViewModel: FavoritesViewModel()
    )
}
