//
//  EmpleadosVM.swift
//  EmpleadosAPI
//
//  Created by Julio César Fernández Muñoz on 20/11/25.
//

import SwiftUI


@Observable @MainActor
final class FavouriteMangaVM {
    
    let repository: NetworkRepository
    
    var manga: Manga?
        
    var state: ViewState = .loading
    var dataLoaded = false
    
    var showError = false
    var errorMsg = ""
    
    init(repository: NetworkRepository = Network()) {
        self.repository = repository
    }
    
    func getManga(_ id: Int) async {
       
        do {
            self.manga = try await repository.getMangaById(id: id)
            
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print(error)
        }
    }    
}
