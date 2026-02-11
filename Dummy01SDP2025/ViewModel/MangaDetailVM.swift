//
//  ThemesView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 19/12/25.
//

import SwiftUI

@Observable @MainActor
final class MangaDetailVM {
    
    let repository: NetworkRepository
    let keychainManager: KeychainManager
    
    var mangaCollection: UserCollection?
    
    var goLogin = false
    
    var inCollection = false
    var mangaDeletedFromCollection = false
    
    var state: ViewState = .loading
    var showError = false
    var errorMsg = ""
    
    var showAlert = false
    var alertMessage = ""
    
    
    
    init(repository: NetworkRepository = Network(), keychainManager: KeychainManager = KeychainManager.shared) {
        self.repository = repository
        self.keychainManager = keychainManager
        //self.loadInitMangas()
    }
    
    func loadInitManga(_ id: Int) {
        
        Task {
            
            do {
                try await self.getMangaCollection(id: id)
            } catch KeychainManager.KeychainError.itemNotFound {
                print("No hay token. Vamos al login ...")
                try? keychainManager.deleteAuthToken()
                goLogin = true
            } catch {
                print("Error al verificar token: \(error.localizedDescription)")
                // Si hay error, cerramos la sesión y para el login
                try? keychainManager.deleteAuthToken()
                goLogin = true
            }
        }
    }
    
    func getMangaCollection(id: Int) async throws {
        
        // Intentar obtener el token del Keychain
        let token = try keychainManager.getAuthToken()
        
        let auth = "Bearer \(token)"
        var headers = [[String: String]]()
        headers.append(["Authorization": auth])
        
        do {
            self.mangaCollection = try await repository.getMangaCollection(headers: headers, id: id)
            self.inCollection = true
            print("Id: \(self.mangaCollection?.id ?? "")")
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print("Collection: \(errorMsg)")
        }
    }
    
    func deleteMangaCollection(id: Int) async  {
            
        do {
            try await self.deleteManga(id: id)
        } catch KeychainManager.KeychainError.itemNotFound {
            print("No hay token. Vamos al login ...")
            try? keychainManager.deleteAuthToken()
            goLogin = true
        } catch {
            print("Error al verificar token: \(error.localizedDescription)")
            // Si hay error, cerramos la sesión y para el login
            try? keychainManager.deleteAuthToken()
            goLogin = true
        }
        
    }
    
    func deleteManga(id: Int) async throws {
        
        let token = try keychainManager.getAuthToken()
        
        let auth = "Bearer \(token)"
        var headers = [[String: String]]()
        headers.append(["Authorization": auth])
        
        do {
            try await repository.deleteMangaCollection(headers: headers, id: id)
            print("MANGA borrado de la colección")
        } catch {
            alertMessage = "No se pudo eliminar el manga de tu colección"
            showAlert.toggle()
        }
    }
    
    func japaneseTitle (
        _ originalTitle: String?,
        _ titleEnglish: String?,
        _ titleStandard: String
    ) -> String {
                   
        var title = ""
        
        guard let titleJapanese = originalTitle else { return title }
        
        if let titleEnglish = titleEnglish {
            if titleEnglish == titleJapanese {
                title = titleEnglish
            }
        } else if titleStandard == titleJapanese {
            title = titleStandard
        } else {
            title = titleJapanese
        }
        
        return title
    }
    
    func linkText(url: URL) -> AttributedString {
        print("\(url.absoluteString)")
        var linkText = AttributedString("Para más info sobre este manga pulsa aquí.")
        linkText.foregroundColor = .gray
        linkText.font = .footnote
        
        if let link = linkText.range(of: "pulsa aquí") {
            linkText[link].link = url
            linkText[link].underlineStyle = .single
            linkText[link].foregroundColor = .blue
        }
        return linkText
    }
}


