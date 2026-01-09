//
//  GenresView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 19/12/25.
//

import SwiftUI

@Observable
@MainActor
final class GenresVM {
    
    let repository: NetworkRepository
    
    let stepPer = 20
    var randomPage = 1
        
    //@ObservationIgnored
    //@AppStorage("totalGenres") private var totalGenres = 0
    
    var totalMangasByGenre = 0
    
    var genres: [String] = []
    var genresDictionary : [String:[Manga]] = [:]
    var randomPageGenresDictionary : [String:Int] = [:]
    
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
                print ("inicio carga de géneros ...")
                self.genres = try await repository.getGenres()
                dataLoaded = true
                try await getMangasByGenre()
                //dataLoaded = true
                print ("Fin de la carga: \(genres.count) géneros")
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
                print(error)
            }
        }
    }
    
    func getMangasByGenre() async throws {
        guard genres.count > 0 else { return }
        
        for genre in self.genres {
        
            await getTotalMangasByGenre(genre: genre)
            self.randomPage = Int.random(in: 1...Int((Double(self.totalMangasByGenre) / Double(self.stepPer)).rounded(.up)))            
            let mangas = try await repository.getMangasByGenre(genre: genre, page: self.randomPage, per: 3)
            self.genresDictionary[genre] = mangas
            self.randomPageGenresDictionary[genre] = self.randomPage
        }
    }
    
    func getTotalMangasByGenre(genre: String) async {
        do {
            self.totalMangasByGenre = try await repository.getTotalList(url: .getMangasByGenre(genre: genre, page: 1, per: 1))
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print(error)
        }
    }
}

