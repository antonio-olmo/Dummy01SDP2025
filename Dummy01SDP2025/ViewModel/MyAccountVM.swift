//
//  MyAccountVM.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 6/1/26.
//

import Foundation

@Observable @MainActor
final class MyAccountVM {
    
    let keychainManager: KeychainManager    
    var showLogin = false
    
    init(keychainManager: KeychainManager = KeychainManager.shared) {        
        self.keychainManager = keychainManager
    }
    
    func getEmail() -> String {
        do {
            return try keychainManager.getAuthEmail()
        } catch {
            return ""
        }
    }
    
    func logout() {
        
        do {
            try keychainManager.deleteAuthToken()
            try keychainManager.deleteAuthEmail()
            print ("Logout correcto: Token borrado del Keychain")
        } catch {
            print("Error al borrarrrr el token: \(error.localizedDescription)")
        }
        
        showLogin.toggle()
    }    
}
