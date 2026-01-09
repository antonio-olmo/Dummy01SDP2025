//
//  SignUpVM.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 31/12/25.
//

import Foundation

@Observable @MainActor
final class SignUpVM {
    
    let repository: NetworkRepository
    
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var isPasswordVisible: Bool = false
    var isConfirmPasswordVisible: Bool = false
    var isLoading: Bool = false
    var acceptTerms: Bool = false
    
    // Estados para validación
    var emailError: String?
    var passwordError: String?
    var confirmPasswordError: String?
    var showAlert: Bool = false
    var alertMessage: String = ""
    
    var isFormValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        emailError == nil &&
        passwordError == nil &&
        confirmPasswordError == nil &&
        acceptTerms
    }
    
    var showError = false
    var errorMsg = ""
    
    init(repository: NetworkRepository = Network()) {
        self.repository = repository
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
        } else if !password.contains(where: { $0.isNumber }) {
            passwordError = "La contraseña debe contener al menos un número"
        } else if !password.contains(where: { $0.isUppercase }) {
            passwordError = "La contraseña debe contener al menos una mayúscula"
        } else {
            passwordError = nil
        }
    }
    
    func validateConfirmPassword(_ confirmPassword: String) {
        if confirmPassword.isEmpty {
            confirmPasswordError = nil
            return
        }
        
        if confirmPassword != password {
            confirmPasswordError = "Las contraseñas no coinciden"
        } else {
            confirmPasswordError = nil
        }
    }
    
    func handleSignUp() async {
        
        isLoading.toggle()
        
        var headers = [[String: String]]()
        
        headers.append(["App-Token": "sLGH38NhEJ0_anlIWwhsz1-LarClEohiAHQqayF0FY"])
        do {
            try await repository.setNewUser(user: User(email: email, password: password), headers: headers)
            alertMessage = "¡Registro exitoso! Ya puedes iniciar sesión."
            showAlert = true
        } catch {
            
            errorMsg = error.localizedDescription
            showError.toggle()
            alertMessage = "\(error.localizedDescription)"
            showAlert = true
            print(error)
        }
    }
}
