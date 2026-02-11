//
//  SearchViewModel.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 16/12/25.
//

import SwiftUI

enum TipoBusqueda: String, Identifiable, CaseIterable {
    case title = "Título del Manga"
    case author = "Autor del Manga (apellido)"
    
    var id: Self { self }
}

@Observable
@MainActor
final class SearchVM {
    
    let repository: NetworkRepository
    
    var searchTask: Task<Void, Never>?
    
    var search = ""
    var mangaResult: [Manga] = []
    
    var busqueda: TipoBusqueda = .title
    var page = 0
    var searchComplete = true
    var lastSearch = false
    var searchContains = true
    
    //var searchType: URL = .findBooks1(search: <#T##String#>)
    
    init(repository: NetworkRepository = Network()) {
        self.repository = repository
    }
    
    func findBooks() async {
        /*do {
            mangaResult = try await repository.findBooks(url: .findBooks2(search: search))
        } catch {
            print(error)
        }*/
        
        do {
            let titleSearch = TitleSearch(
                searchContains: searchContains,
                searchTitle: search
            )
            page += 1
            let mangaResult2 = try await repository.findMangaByTitle(page: page, per: 20, titleSearch: titleSearch)
            lastSearch = mangaResult2.count < 20 ? true : false
            mangaResult.append(contentsOf: mangaResult2)
            print("Page \(page): \(mangaResult.count)")
        } catch {
            print(error)
        }
    }
    
    func findAuthors() async {
        do {
            let authorSearch = AuthorSearch(
                searchContains: searchContains,
                searchAuthorLastName: search
            )
            page += 1
            let mangaResult2 = try await repository.findMangaByAuthor(page: page, per: 20, authorSearch: authorSearch)
            lastSearch = mangaResult2.count < 20 ? true : false
            mangaResult.append(contentsOf: mangaResult2)
            print("Page \(page): \(mangaResult.count)")
        } catch {
            print(error)
        }
    }
    
    func initSearch() {
        search = ""
        mangaResult = []
    }
    
    func searching() {
        if search.count > 2 {
            
            //if searchComplete {
                //searchComplete = false
                page = 0
                mangaResult = []
                
                // Cancelar la búsqueda pendiente si existe
                searchTask?.cancel()
                
                // Crear nueva tarea con delay de 300ms
                searchTask = Task {
                    do {
                        searchComplete = false
                        try await Task.sleep(for: .milliseconds(300))
                        
                        // Verificar si la tarea no fue cancelada
                        guard !Task.isCancelled else {
                            //searchComplete = true
                            return
                        }
                        
                        print("Inicio búsqueda")
                        
                        busqueda == .title ? await findBooks() : await findAuthors()
                        print("Fin búsqueda")
                        searchComplete = true
                    } catch {
                        // Task fue cancelada o hubo error en sleep
                        print("Búsqueda cancelada")
                        searchComplete = search.count > 2 ? false : true
                    }
                }
            //}
        } else {
            // Cancelar cualquier búsqueda pendiente cuando hay menos de 3 caracteres
            searchTask?.cancel()
            searchComplete = true
            mangaResult = []
        }
    }
    
}
