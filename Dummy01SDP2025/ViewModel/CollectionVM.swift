//
//  ThemesView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 19/12/25.
//

import SwiftUI

@Observable
@MainActor
final class ThemesVM {
    
    let repository: NetworkRepository
    
    let stepPer = 20
    var randomPage = 1
        
    //@ObservationIgnored
    //@AppStorage("totalThemes") private var totalThemes = 0
    
    var totalMangasByTheme = 0
    
    var themes: [String] = []
    var themesDictionary : [String:[Manga]] = [:]
    var randomPageThemesDictionary : [String:Int] = [:]
    
    var dataLoaded = false
    
    var showError = false
    var errorMsg = ""
    
    init(repository: NetworkRepository = Network()) {
        self.repository = repository
        //self.loadInitMangas()
    }
    
    func loadInitMangas() {
        Task {
            do {
                print ("inicio carga de Temas ...")
                self.themes = try await repository.getThemes()
                dataLoaded = true
                try await getMangasByTheme()
                //dataLoaded = true
                print ("Fin de la carga: \(themes.count) temas")
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
                print(error)
            }
        }
    }
    
    func getMangasByTheme() async throws {
        guard themes.count > 0 else { return }
        
        for theme in self.themes {
        
            await getTotalMangasByTheme(theme: theme)
            self.randomPage = Int.random(in: 1...Int((Double(self.totalMangasByTheme) / Double(self.stepPer)).rounded(.up)))
            let mangas = try await repository.getMangasByTheme(theme: theme, page: self.randomPage, per: 3)
            self.themesDictionary[theme] = mangas
            self.randomPageThemesDictionary[theme] = self.randomPage
        }
    }
    
    func getTotalMangasByTheme(theme: String) async {
        do {
            self.totalMangasByTheme = try await repository.getTotalList(url: .getMangasByTheme(theme: theme, page: 1, per: 1))
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print(error)
        }
    }
}

