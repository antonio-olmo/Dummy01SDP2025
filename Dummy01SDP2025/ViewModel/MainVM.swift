//
//  MainVM.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 6/1/26.
//

import Foundation

@Observable @MainActor
final class MainVM {
    
    let repository: NetworkRepository
    let keychainManager: KeychainManager
    
    var isVerifying = false
    var isAuthenticated = false
    var isInitializing = true
    
    init(repository: NetworkRepository = Network(),
         keychainManager: KeychainManager = KeychainManager.shared) {
        self.repository = repository
        self.keychainManager = keychainManager
    }
    
    func checkInitialAuthentication() async {
                
        do {
            try await manageRenewedToken()
        } catch KeychainManager.KeychainError.itemNotFound {
            print("No hay token guardado. Nos vamos al login")
            isAuthenticated = false
        } catch {
            print("Error en verificación inicial: \(error.localizedDescription)")
            isAuthenticated = false
        }
        
        // Esperar un momento para que se vea la animación, no sé si quitarlo ...
        //try? await Task.sleep(for: .milliseconds(500))
        
        isInitializing = false
    }    
    
    func onAppEnterForeground() {
        print("Volvamos a fore y verificamos sesión ...")
        
        // Solo verificar si el usuario está autenticado
        guard isAuthenticated else {
            print("Autenticación incorrecta")
            return
        }
        
        isVerifying = true
        
        Task {
            do {
                try await manageRenewedToken()
            } catch KeychainManager.KeychainError.itemNotFound {
                print("No hay token. Vamos al login ...")
                isAuthenticated = false
            } catch {
                print("Error al verificar token: \(error.localizedDescription)")
                // Si hay error, cerramos la sesión y para el login
                isAuthenticated = false
            }
            
            // Esperar un momento para que se vea la animación, no sé si quitarlo ...
            //try? await Task.sleep(for: .milliseconds(500))
            
            isVerifying = false
        }
    }
    
    func manageRenewedToken() async throws {
        
        // Intentar obtener el token del Keychain
        let token = try keychainManager.getAuthToken()
        
        let auth = "Bearer \(token)"
        
        var headers = [[String: String]]()
        
        headers.append(["Authorization": auth])
        do {
            let newToken = try await repository.renew(headers: headers)
            
            // Almacenamos el token renovado en el Keychain
            do {
                try keychainManager.saveAuthToken(newToken.token)
                print("Token renovado: \(newToken.token)")
                isAuthenticated = true
            } catch {
                try keychainManager.deleteAuthToken()
                isAuthenticated = false
                
                print("Keychain error: \(error)")
            }
            
        } catch {
            
            try keychainManager.deleteAuthToken()
            isAuthenticated = false
            
            print(error)
        }        
    }
}
