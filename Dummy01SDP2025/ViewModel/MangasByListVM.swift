//
//  ThemesView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 19/12/25.
//

import SwiftUI

@Observable
@MainActor
final class MangasByListVM {
    
    let repository: NetworkRepository
        
    let stepPer = 20
        
    //@ObservationIgnored
    //@AppStorage("totalThemes") private var totalThemes = 0
    
    var totalMangasByList = 0
    
    var item: String
    var itemDictionary : [String:[Manga]]
    var randomPage: Int
    var list: Int = 0
    
    var showError = false
    var errorMsg = ""
    
    init(repository: NetworkRepository = Network(), item: String, itemDictionary : [String:[Manga]], randomPage: Int, list: Int) {
        self.repository = repository
        self.item = item
        self.itemDictionary = itemDictionary
        self.randomPage = randomPage
        self.list = list
        self.loadInitMangas()
    }
    
    func loadInitMangas() {
        Task {
            do {
                try await getMangasByList()
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
                print(error)
            }
        }
    }
    
    func getMangasByList() async throws {
        guard item != "" && list != 0 else { return }
        
        
        
            //await getTotalMangasByTheme(theme: theme)
            //let randomPage = Int.random(in: 1...Int((Double(self.totalMangasByTheme) / Double(self.stepPer)).rounded(.up)))
        var page = randomPage
        for num in 1...10 {
            var mangas: [Manga] = []
            switch self.list {
                case 1:
                    mangas = try await repository.getMangasByTheme(theme: item, page: page, per: 3)
                case 2:
                    mangas = try await repository.getMangasByGenre(genre: item, page: page, per: 3)
                default:
                    mangas = try await repository.getMangasByDemographic(demographic: item, page: page, per: 3)
            }
            
            if num == 1 {
                self.itemDictionary[item] = mangas
            } else {
                self.itemDictionary[item]?.append(contentsOf: mangas)
            }
            page += 1
        }        
    }
}

