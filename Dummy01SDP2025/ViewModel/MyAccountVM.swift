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
    
    func logout() {
        
        do {
            try keychainManager.deleteAuthToken()
            print ("Logout correcto: Token borrado del Keychain")
        } catch {
            print("Error al borrarrrr el token: \(error.localizedDescription)")
        }
        
        showLogin.toggle()
    }    
}
