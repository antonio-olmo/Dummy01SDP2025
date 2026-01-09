//
//  SignInVM.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 1/1/26.
//

import Foundation
import SwiftUI

@Observable @MainActor
final class SignInVM {
    
    let repository: NetworkRepository
    let keychainManager: KeychainManager
    
    var email: String = ""
    var password: String = ""
    var isPasswordVisible: Bool = false
    var isLoading: Bool = false
    var hasAuthentication: Bool = false
    
    // Estados para validación
    var emailError: String?
    var passwordError: String?
    var showAlert: Bool = false
    var alertMessage: String = ""
    
    var showSignUp: Bool = false
    
    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && emailError == nil && passwordError == nil
    }
    
    var showError = false
    var errorMsg = ""
    
    // Recibimos el VM de Main para poder usarlo en este VM
    var mainVM: MainVM? = nil
    
    init(repository: NetworkRepository = Network(), 
         keychainManager: KeychainManager = KeychainManager.shared
    ) {
        self.repository = repository
        self.keychainManager = keychainManager
    }
    
    func validateEmail(_ email: String) {
        if email.isEmpty {
            emailError = nil
            return
        }
        
        let emailRegex = /^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$/
        
        if email.wholeMatch(of: emailRegex) == nil {
            emailError = "Correo electrónico inválido"
        } else {
            emailError = nil
        }        
    }
    
    func validatePassword(_ password: String) {
        if password.isEmpty {
            passwordError = nil
            return
        }
        
        if password.count < 8 {
            passwordError = "La contraseña debe tener al menos 8 caracteres"
        } else {
            passwordError = nil
        }
    }
    
    func handleSignIn() async {
        
        let username = email
        let password = password

        let credentials = "\(username):\(password)"
        guard let encodedCredentials = credentials.data(using: .utf8) else {
            isLoading = false
            return
        }
        
        let auth = "Basic \(encodedCredentials.base64EncodedString())"
        
        var headers = [[String: String]]()
        headers.append(["Authorization": auth])
        
        do {
            let token = try await repository.login(headers: headers)
            
            // Almacenamos el token en el Keychain de forma segura
            do {
                try keychainManager.saveAuthToken(token.token)
                print("Token guardado en Keychain: \(token.token)")
                
                isLoading = false
                hasAuthentication.toggle()
                mainVM?.isAuthenticated = true
                
            } catch {
                // Error al guardar en el Keychain
                errorMsg = "Error al guardar credenciales: \(error.localizedDescription)"
                showError = true
                alertMessage = "Error al guardar las credenciales de forma segura"
                showAlert = true
                isLoading = false
                print("Error al guaradar token en Keychain: \(error)")
            }
            
        } catch {
            errorMsg = error.localizedDescription
            showError = true
            alertMessage = "\(error.localizedDescription)"
            showAlert = true
            isLoading = false
            print("Login error: \(error)")
        }
    }
}
