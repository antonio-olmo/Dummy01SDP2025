//
//  ThemesView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 19/12/25.
//

import SwiftUI

@Observable @MainActor
final class CollectionVM {
    
    let repository: NetworkRepository
    let keychainManager: KeychainManager
    
    var userCollection: [UserCollection] = []
        
    var state: ViewState = .loading
    
    var goLogin = false
    
    var showError = false
    var errorMsg = ""
    
    init(repository: NetworkRepository = Network(), keychainManager: KeychainManager = KeychainManager.shared) {
        self.repository = repository
        self.keychainManager = keychainManager
        //self.loadInitMangas()
    }
    
    func loadInitMangas() {
        
        Task {
            
            do {
                try await self.getCollection()
            } catch KeychainManager.KeychainError.itemNotFound {
                print("No hay token. Vamos al login ...")
                goLogin = true
            } catch {
                print("Error al verificar token: \(error.localizedDescription)")
                // Si hay error, cerramos la sesión y para el login
                goLogin = true
            }
        }
    }
    
    func getCollection() async throws {
        
        // Intentar obtener el token del Keychain
        let token = try keychainManager.getAuthToken()
        
        let auth = "Bearer \(token)"
        var headers = [[String: String]]()
        headers.append(["Authorization": auth])
        
        do {
            self.userCollection = try await repository.getCollection(headers: headers)
            print("Colección: \(self.userCollection.count)")
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print("Collection: \(error)")
        }
    }
}


