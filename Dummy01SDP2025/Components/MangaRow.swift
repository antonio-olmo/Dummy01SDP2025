//
//  MangaRow.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 22/12/25.
//

import SwiftUI

struct MangaRow: View {
    
    let manga: Manga
    
    var body: some View {
        /*VStack (alignment: .leading) {
            Text("\(manga.title)")
                .font(.headline)
            
            MangaCoverView(urlString: manga.mainPicture ?? "")
            
            HStack (alignment: .top) {
                VStack (alignment: .leading) {
                    ForEach (manga.genres, id: \.self) { genre in
                        
                        Text(genre.genre)
                            .font(.footnote)
                    }
                }
                
                Spacer()
                
                VStack (alignment: .trailing) {
                    ForEach (manga.authors) { author in
                        
                        Text(author.lastName)
                            .font(.footnote)
                    }
                }
            }
        }
        Divider()*/
        
        VStack(alignment: .leading, spacing: 6) {
            // Primera fila: Dos columnas con título y (imagen + rating)
            HStack(alignment: .top, spacing: 0) {
                // Columna izquierda: Título
                
                VStack {
                    Spacer()
                    Text(manga.title)
                        .font(.title3)
                        .fontWeight(.medium)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                
                Spacer(minLength: 16)
                
                // Columna derecha: VStack con imagen y rating
                VStack(spacing: 8) {
                    MangaCoverView(urlString: manga.mainPicture ?? "")
                        .frame(maxHeight: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.6),
                                            Color.white.opacity(0.3),
                                            Color.purple.opacity(0.4),
                                            Color.blue.opacity(0.5)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(color: Color(red: 0.3, green: 0.2, blue: 0.5).opacity(0.7), radius: 20, x: 0, y: 10)                        
                                        
                    RatingView(rating: (manga.score * 5) / 10, originalRating: manga.score < 0 ? 0 : manga.score)
                    .scaleEffect(0.6)
                    .frame(height: 20)
                }
                .frame(width: 160)
            }
            
            // Separador con degradado
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
            
            // Autores
            if !manga.authors.isEmpty {
                Text("**Autores:** \(formatAuthors())")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Temas
            if !manga.themes.isEmpty {
                Text("**Temas:** \(formatThemes())")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Géneros
            if !manga.genres.isEmpty {
                Text("**Géneros:** \(formatGenres())")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Demografías
            if !manga.demographics.isEmpty {
                Text("**Demografía:** \(formatDemographics())")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            randomPastelColor(seed: Int.random(in: manga.id...(manga.id + 25))).opacity(0.12),
                            randomPastelColor(seed: Int.random(in: (manga.id + 25)...(manga.id + 35))).opacity(0.24)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }
    
    private func randomPastelColor(seed: Int) -> Color {
        let hue = Double((seed * 137) % 360) / 360.0 // Ángulo dorado para mejor distribución
        return Color(hue: hue, saturation: 0.8, brightness: 0.95)
    }
    
    private func formatAuthors() -> String {
        manga.authors
            .map { "\($0.firstName) \($0.lastName)" }
            .joined(separator: ", ")
    }
    
    private func formatThemes() -> String {
        manga.themes
            .map { $0.theme }
            .joined(separator: ", ")
    }
    
    private func formatGenres() -> String {
        manga.genres
            .map { $0.genre }
            .joined(separator: ", ")
    }
    
    private func formatDemographics() -> String {
        manga.demographics
            .map { $0.demographic }
            .joined(separator: ", ")
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            ForEach(Manga.testMangas) { manga in
                MangaRow(manga: manga)
            }
        }
        .padding()
    }
}
