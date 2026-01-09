//
//  ThemesView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 19/12/25.
//

import SwiftUI

@Observable
@MainActor
final class ListsVM {
    
    let repository: NetworkRepository
    
    let stepPer = 20
    var randomPage = 1
        
    //@ObservationIgnored
    //@AppStorage("totalThemes") private var totalThemes = 0
    
    var totalMangasByList = 0
    
    var lists: [String] = []
    var listsDictionary : [String:[Manga]] = [:]
    var randomPageListsDictionary : [String:Int] = [:]
    
    var selectedItem = "Temas"
    let items = ["Temas", "Géneros", "Demografía"]
    var dataThemesLoaded = false
    var dataGenresLoaded = false
    var dataDemographicsLoaded = false
    
    var showError = false
    var errorMsg = ""
    
    init(repository: NetworkRepository = Network()) {
        self.repository = repository
        //self.loadInitMangas()
    }
    
    func loadInitMangas() {
        Task {
            do {
                print ("inicio carga de Listas ...")
                switch selectedItem {
                case "Temas":
                    self.lists = try await repository.getThemes()
                case "Géneros":
                    self.lists = try await repository.getGenres()
                default:
                    self.lists = try await repository.getDemographics()
                }
                
                try await getMangasByList()
                
                switch selectedItem {
                case "Temas":
                    dataThemesLoaded = true
                case "Géneros":
                    dataGenresLoaded = true
                default:
                    dataDemographicsLoaded = true
                }
                
                print ("Fin de la carga: \(lists.count) items")
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
                print(error)
            }
        }
    }
    
    func getMangasByList() async throws {
        guard lists.count > 0 else { return }
        
        for list in self.lists {
        
            await getTotalMangasByList(list: list)
            self.randomPage = Int.random(in: 1...Int((Double(self.totalMangasByList) / Double(self.stepPer)).rounded(.up)))
            
            var mangas: [Manga] = []
            
            switch selectedItem {
            case "Temas":
                mangas = try await repository.getMangasByTheme(theme: list, page: self.randomPage, per: 3)
            case "Géneros":
                mangas = try await repository.getMangasByGenre(genre: list, page: self.randomPage, per: 3)
            default:
                mangas = try await repository.getMangasByDemographic(demographic: list, page: self.randomPage, per: 3)
            }            
            
            self.listsDictionary[list] = mangas
            self.randomPageListsDictionary[list] = self.randomPage
        }
    }
    
    func getTotalMangasByList(list: String) async {
        do {
            
            switch selectedItem {
            case "Temas":
                self.totalMangasByList = try await repository.getTotalList(url: .getMangasByTheme(theme: list, page: 1, per: 1))
            case "Géneros":
                self.totalMangasByList = try await repository.getTotalList(url: .getMangasByGenre(genre: list, page: 1, per: 1))
            default:
                self.totalMangasByList = try await repository.getTotalList(url: .getMangasByDemographic(demographic: list, page: 1, per: 1))
            }            
            
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print(error)
        }
    }
}

