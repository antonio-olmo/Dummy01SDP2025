//
//  NetworkRepository.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 14/12/25.
//

import Foundation

protocol NetworkRepository: Sendable, NetworkInteractor {
    
    func setNewUser(user: User, headers: [[String:String]]) async throws(NetworkError)
    func login(headers: [[String:String]]) async throws(NetworkError) -> Token
    func renew(headers: [[String:String]]) async throws(NetworkError) -> Token
    
    func getTotalList(url: URL) async throws(NetworkError) -> Int
    //func getTotalMangas() async throws(NetworkError) -> Int
    func getMangas(page: Int, per: Int) async throws(NetworkError) -> [Manga]
    func getMangasByTheme(theme: String, page: Int, per: Int) async throws(NetworkError) -> [Manga]
    func getMangasByGenre(genre: String, page: Int, per: Int) async throws(NetworkError) -> [Manga]
    func getBestMangas() async throws(NetworkError) -> [Manga]
    func getThemes() async throws(NetworkError) -> [String]
    func getGenres() async throws(NetworkError) -> [String]
    func getDemographics() async throws(NetworkError) -> [String]
    func getMangasByDemographic(demographic: String, page: Int, per: Int) async throws(NetworkError) -> [Manga]
    func findBooks(url: URL) async throws -> [Manga]
    //func findBooks(search: String) async throws -> [Manga]
}

struct Network: NetworkRepository {
    
    func setNewUser(user: User, headers: [[String:String]]) async throws(NetworkError) {
        try await postJSON(.post(url: .setNewUser, body: user, headers: headers), status: 201)
    }
    
    func login(headers: [[String:String]]) async throws(NetworkError) -> Token {
        return try await postJSON(.post(url: .login, headers: headers), type: Token.self)
    }
    
    func renew(headers: [[String:String]]) async throws(NetworkError) -> Token {
        return try await postJSON(.post(url: .renew, headers: headers), type: Token.self)
    }
    
    func getTotalList(url: URL) async throws(NetworkError) -> Int {
        let resultados = try await getJSON(.get(url: url), type: BasicMangaDTO.self)
        return resultados.metadata.total
    }
    
    /*func getTotalMangas() async throws(NetworkError) -> Int {
        let resultados = try await getJSON(.get(url: .getMangas(page: 1, per: 1)), type: BasicMangaDTO.self)
        return resultados.metadata.total
    }*/
    
    func getMangas(page: Int, per: Int) async throws(NetworkError) -> [Manga] {
        //let resultados = try await getJSON(.get(url: .getBestMangas), type: [MangaDTO].self).map(\.toManga)
        let resultados = try await getJSON(.get(url: .getMangas(page: page, per: per)), type: BasicMangaDTO.self)
        return resultados.items.map { $0.toManga }
    }
    
    func getBestMangas() async throws(NetworkError) -> [Manga] {
        //let resultados = try await getJSON(.get(url: .getBestMangas), type: [MangaDTO].self).map(\.toManga)
        let resultados = try await getJSON(.get(url: .getBestMangas), type: BasicMangaDTO.self)
        return resultados.items.map { $0.toManga }
    }
    
    func getThemes() async throws(NetworkError) -> [String] {
        try await getJSON(.get(url: .getThemes), type: [String].self) //.map { $0.toTheme.theme }
    }
    
    func getMangasByTheme(theme: String, page: Int, per: Int) async throws(NetworkError) -> [Manga] {
        let resultados = try await getJSON(.get(url: .getMangasByTheme(theme: theme, page: page, per: per)), type: BasicMangaDTO.self)
        return resultados.items.map { $0.toManga }
    }
    
    func getGenres() async throws(NetworkError) -> [String] {
        try await getJSON(.get(url: .getGenres), type: [String].self) //.map { $0.toTheme.theme }
    }
    
    func getMangasByGenre(genre: String, page: Int, per: Int) async throws(NetworkError) -> [Manga] {
        let resultados = try await getJSON(.get(url: .getMangasByGenre(genre: genre, page: page, per: per)), type: BasicMangaDTO.self)
        return resultados.items.map { $0.toManga }
    }
    
    func getDemographics() async throws(NetworkError) -> [String] {
        try await getJSON(.get(url: .getDemographics), type: [String].self) //.map { $0.toTheme.theme }
    }
    
    func getMangasByDemographic(demographic: String, page: Int, per: Int) async throws(NetworkError) -> [Manga] {
        let resultados = try await getJSON(.get(url: .getMangasByDemographic(demographic: demographic, page: page, per: per)), type: BasicMangaDTO.self)
        return resultados.items.map { $0.toManga }
    }
    
    func findBooks(url: URL) async throws -> [Manga] {
        if url.pathComponents[url.pathComponents.count - 2] == "mangasBeginsWith" {
            return try await getJSON(.get(url: url), type: [MangaDTO].self).map { $0.toManga }
        } else {
            return try await getJSON(.get(url: url), type: BasicMangaDTO.self).items.map { $0.toManga }
        }
    }
}
