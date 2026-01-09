//
//  URL.swift
//  EmpleadosAPI
//
//  Created by Julio César Fernández Muñoz on 19/11/25.
//

import Foundation

let api = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com")!

extension URL {
    
    static let setNewUser = api
        .appending(path: "users")
    
    static let login = api
        .appending(path: "users")
        .appending(path: "login")
    
    static let renew = api
        .appending(path: "users")
        .appending(path: "renew")
    
    static func getMangas (page: Int, per: Int) -> URL {
        api
            .appending(path: "list")
            .appending(path: "mangas")
            .appending(queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per", value: "\(per)")
            ])
    }
    
    static let getBestMangas = api
        .appending(path: "list")
        .appending(path: "bestMangas")
        /*.appending(queryItems: [
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "per", value: "20")
        ])*/
    
    static let getThemes = api
        .appending(path: "list")
        .appending(path: "themes")
    
    static func getMangasByTheme(theme: String, page: Int, per: Int) -> URL {
        api
            .appending(path: "list")
            .appending(path: "mangaByTheme")
            .appending(path: theme)
            .appending(queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per", value: "\(per)")
            ])
    }
    
    static let getGenres = api
        .appending(path: "list")
        .appending(path: "genres")
    
    static func getMangasByGenre(genre: String, page: Int, per: Int) -> URL {
        api
            .appending(path: "list")
            .appending(path: "mangaByGenre")
            .appending(path: genre)
            .appending(queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per", value: "\(per)")
            ])
    }
    
    static let getDemographics = api
        .appending(path: "list")
        .appending(path: "demographics")
    
    static func getMangasByDemographic(demographic: String, page: Int, per: Int) -> URL {
        api
            .appending(path: "list")
            .appending(path: "mangaByDemographic")
            .appending(path: demographic)
            .appending(queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per", value: "\(per)")
            ])
    }
    
    static func findBooks1(search: String) -> URL {
        api.appending(path: "/search/mangasContains").appending(path: search)
    }
    
    static func findBooks2(search: String) -> URL {
        api.appending(path: "/search/mangasBeginsWith").appending(path: search)
    }
    
}
