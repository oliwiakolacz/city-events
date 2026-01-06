//
//  AboutView.swift
//  AboutView
//
//  Created by Oliwia Kołacz on 06/01/2026.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "calendar.badge.checkmark")
                            .font(.system(size: 80))
                            .foregroundStyle(.blue.gradient)
                        
                        Text("City Events")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Wersja 1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    
                    // Autor
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Autor", systemImage: "person.circle.fill")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            Text("Oliwia Kołacz")
                                .font(.title3)
                                .fontWeight(.medium)
                            
                            Text("Projekt: Programowanie urządzeń mobilnych")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                    
                    // Opis
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("O Aplikacji", systemImage: "info.circle.fill")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            Text("Aplikacja do przeglądania wydarzeń kulturalnych i sportowych w różnych miastach. Korzysta z Ticketmaster API, aby dostarczać aktualne informacje o koncertach, meczach, spektaklach i innych wydarzeniach.")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                    
                    // Funkcjonalności
                    GroupBox {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Funkcjonalności", systemImage: "star.fill")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            FeatureRow(icon: "magnifyingglass", title: "Przeglądanie wydarzeń", description: "Z różnych miast w Europie")
                            FeatureRow(icon: "slider.horizontal.3", title: "Zaawansowane filtry", description: "Kategorie, daty, miasta")
                            FeatureRow(icon: "heart.fill", title: "Ulubione", description: "Zapisuj interesujące wydarzenia")
                            FeatureRow(icon: "info.circle", title: "Szczegóły", description: "Pełne informacje o wydarzeniach")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                    
                    // Technologie
                    GroupBox {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Technologie", systemImage: "hammer.fill")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            TechRow(name: "SwiftUI", description: "Nowoczesny interfejs użytkownika")
                            TechRow(name: "SwiftData", description: "Lokalna baza danych")
                            TechRow(name: "Async/Await", description: "Asynchroniczne operacje")
                            TechRow(name: "Ticketmaster API", description: "Źródło danych o wydarzeniach")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                    
                    // Copyright
                    Text("Autor: Oliwia Kołacz\n")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                }
            }
            .navigationTitle("O Aplikacji")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Supporting Views

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct TechRow: View {
    let name: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(name)
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    AboutView()
}
