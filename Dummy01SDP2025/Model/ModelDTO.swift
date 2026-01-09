//
//  ModelDTO.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 14/12/25.
//

import Foundation

struct BasicMangaDTO: Codable {
    let items: [MangaDTO]
    let metadata: MetaData
}

struct MetaData: Codable {
    let total: Int
    let page: Int
    let per: Int
}

struct MangaDTO: Codable, Identifiable {
    
    let id: Int // Unique manga identifier
    
    let url: String? // URL to the manga information page

    let score: Double // Average user score from 0 to 10

    let mainPicture: String? // URL to the main cover image

    let sypnosis: String? // Plot synopsis/description

    let title: String // Original manga title

    let volumes: Int? // Total number of published volumes

    let startDate: String? //Date? // Publication start date

    let status: String //discontinued → discontinued • on_hiatus → on_hiatus • currently_publishing → publishing • finished → finished • none → none

    let authors: [AuthorDTO] // List of authors and artists

    let themes: [ThemeDTO] // List of themes
    
    let demographics: [DemographicDTO]
    
    let titleEnglish: String? // English title

    let background: String? // Background information about the manga

    let chapters: Int? // Total number of chapters

    let titleJapanese: String? // Japanese title (日本語)

    let genres: [GenreDTO]
    
    let endDate: String? //Date?
}

struct AuthorDTO: Codable, Identifiable {
    let id: UUID
    let role: String
    let lastName: String
    let firstName: String
}

struct ThemeDTO: Codable, Identifiable {
    let id: UUID
    let theme: String
}

struct DemographicDTO: Codable, Identifiable {
    let id: UUID
    let demographic: String
}

struct GenreDTO: Codable, Identifiable {
    let id: UUID
    let genre: String
}

extension AuthorDTO {
    var toAuthor: Author {
        Author(
            id: id,
            role: Roles(rawValue: role) ?? .none,
            lastName: lastName,
            firstName: firstName
        )
    }
}

extension GenreDTO {
    var toGenre: Genre {
        Genre(id: id, genre: genre)
    }
}

extension ThemeDTO {
    var toTheme: Theme {
        Theme(id: id, theme: theme)
    }
}

extension DemographicDTO {
    var toDemographic: Demographic {
        Demographic(id: id, demographic: demographic)
    }
}

extension MangaDTO {
    var toManga: Manga {
        
        Manga(
            id: id,
            url: URL(string: url ?? ""),
            score: score,
            mainPicture: mainPicture,
            sypnosis: sypnosis,
            title: title,
            volumes: volumes,
            startDate: startDate,
            status: Status(rawValue: status) ?? Status.none,
            authors: authors.map { $0.toAuthor },
            themes: themes.map { $0.toTheme },
            demographics: demographics.map { $0.toDemographic },
            titleEnglish: titleEnglish,
            background: background ?? "",
            chapters: chapters ?? 0,
            titleJapanese: titleJapanese,
            genres: genres.map { $0.toGenre.genre },
            endDate: endDate
        )
    }
    
    /*func getURL(mainPicture: String?) -> String {
        if let mainPicture {
            print("URL: \(mainPicture)")
            return mainPicture.filter { $0 != "\"" }
        } else {
            return ""
        }
    }*/
}
