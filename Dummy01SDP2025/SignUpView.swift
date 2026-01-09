//
//  SignUpView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 31/12/25.
//

import SwiftUI

struct SignUpView: View {
        
    @Environment(\.dismiss) private var dismiss
    @State private var vm = SignUpVM()
        
    var body: some View {
        
        ZStack {
            // Fondo degradado blanco a gris estilo manga
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.white, location: 0.0),
                    .init(color: Color(white: 0.95), location: 0.2),
                    .init(color: Color(white: 0.90), location: 0.5),
                    .init(color: Color(white: 0.85), location: 0.75),
                    .init(color: Color(white: 0.80), location: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Overlay con textura de papel manga (blur)
            Rectangle()
                .fill(Color.black.opacity(0.02))
                .ignoresSafeArea()
                .blur(radius: 50)
            
            // Contenido principal
            ScrollView {
                VStack(spacing: 30) {
                    Spacer()
                        .frame(height: 20)
                    
                    // Logo y título
                    headerSection
                    
                    // Formulario con efecto de cristal mejorado
                    GlassEffectContainer(spacing: 20) {
                        VStack(spacing: 20) {
                            emailField
                            passwordField
                            confirmPasswordField
                            termsCheckbox
                            signUpButton
                        }
                        .padding(30)
                        .background(
                            // Capa semi-opaca clara detrás del cristal para legibilidad en fondo blanco
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.white.opacity(0.7))
                        )
                        .glassEffect(.regular, in: .rect(cornerRadius: 24))
                    }
                    .padding(.horizontal, 24)
                    
                    // Opciones adicionales
                    footerSection
                    
                    Spacer()
                }
            }
        }
        .alert("Registro de Usuario", isPresented: $vm.showAlert) {
            Button("OK", role: .cancel) {
                if vm.alertMessage.contains("exitoso") {
                    dismiss()
                } else {
                    vm.isLoading.toggle()
                }
            }
        } message: {
            Text(vm.alertMessage)
        }
    }
    
    // Vistas
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Icono de avatar con efecto cristal y estilo manga
            ZStack {
                // Círculo de fondo con gradiente gris
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(white: 0.8),
                                Color(white: 0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)
                    .overlay(
                        Circle()
                            .strokeBorder(Color.black.opacity(0.3), lineWidth: 2)
                    )
                
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.black, Color(white: 0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .glassEffect(.regular.interactive(), in: .circle)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            Text("Crear Cuenta")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .shadow(color: .white.opacity(0.8), radius: 2, x: 0, y: 0)
            
            HStack (spacing: 0) {
                Text("Únete a la comunidad ")
                Text("SAOTOME Manga")
                    .bold()
            }
            .font(.subheadline)
            .foregroundColor(.black.opacity(0.7))
            .shadow(color: .white.opacity(0.5), radius: 1, x: 0, y: 0)
        }
    }
    
    private var emailField: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: "envelope.fill")
                    .foregroundColor(.black.opacity(0.7))
                    .frame(width: 20)
                
                TextField("", text: $vm.email, prompt: Text("Correo electrónico").foregroundColor(.black.opacity(0.4)))
                    .textFieldStyle(.plain)
                    .foregroundColor(.black)
                    .font(.body)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .onChange(of: vm.email) { _, newValue in
                        vm.validateEmail(newValue)
                    }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(vm.emailError != nil ? Color.red.opacity(0.8) : Color.black.opacity(0.3), lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            if let error = vm.emailError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red.opacity(0.9))
                    .padding(.leading, 4)
                    .shadow(color: .white.opacity(0.8), radius: 1, x: 0, y: 0)
            }
        }
    }
    
    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: "lock.fill")
                    .foregroundColor(.black.opacity(0.7))
                    .frame(width: 20)
                
                Group {
                    if vm.isPasswordVisible {
                        TextField("", text: $vm.password, prompt: Text("Contraseña").foregroundColor(.black.opacity(0.4)))
                            .textFieldStyle(.plain)
                    } else {
                        SecureField("", text: $vm.password, prompt: Text("Contraseña").foregroundColor(.black.opacity(0.4)))
                            .textFieldStyle(.plain)
                    }
                }
                .foregroundColor(.black)
                .font(.body)
                .textContentType(.newPassword)
                .onChange(of: vm.password) { _, newValue in
                    vm.validatePassword(newValue)
                    // Revalidar confirmación si ya tiene contenido
                    if !vm.confirmPassword.isEmpty {
                        vm.validateConfirmPassword(vm.confirmPassword)
                    }
                }
                
                Button(action: {
                    vm.isPasswordVisible.toggle()
                }) {
                    Image(systemName: vm.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.black.opacity(0.7))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(vm.passwordError != nil ? Color.red.opacity(0.8) : Color.black.opacity(0.3), lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            if let error = vm.passwordError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red.opacity(0.9))
                    .padding(.leading, 4)
                    .shadow(color: .white.opacity(0.8), radius: 1, x: 0, y: 0)
            }
        }
    }
    
    private var confirmPasswordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: "lock.fill")
                    .foregroundColor(.black.opacity(0.7))
                    .frame(width: 20)
                
                Group {
                    if vm.isConfirmPasswordVisible {
                        TextField("", text: $vm.confirmPassword, prompt: Text("Confirmar contraseña").foregroundColor(.black.opacity(0.4)))
                            .textFieldStyle(.plain)
                    } else {
                        SecureField("", text: $vm.confirmPassword, prompt: Text("Confirmar contraseña").foregroundColor(.black.opacity(0.4)))
                            .textFieldStyle(.plain)
                    }
                }
                .foregroundColor(.black)
                .font(.body)
                .textContentType(.newPassword)
                .onChange(of: vm.confirmPassword) { _, newValue in
                    vm.validateConfirmPassword(newValue)
                }
                
                Button(action: {
                    vm.isConfirmPasswordVisible.toggle()
                }) {
                    Image(systemName: vm.isConfirmPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.black.opacity(0.7))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(vm.confirmPasswordError != nil ? Color.red.opacity(0.8) : Color.black.opacity(0.3), lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            if let error = vm.confirmPasswordError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red.opacity(0.9))
                    .padding(.leading, 4)
                    .shadow(color: .white.opacity(0.8), radius: 1, x: 0, y: 0)
            }
        }
    }
    
    private var termsCheckbox: some View {
        Button(action: {
            vm.acceptTerms.toggle()
        }) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if vm.acceptTerms {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
                
                Text("Acepto los términos y condiciones")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.8))
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    private var signUpButton: some View {
        Button(action: {
            Task {
                await vm.handleSignUp()
            }
        }) {
            HStack {
                if vm.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Crear Cuenta")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                Group {
                    if vm.isFormValid {
                        // Fondo oscuro cuando está activo (estilo manga)
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.9),
                                Color.black.opacity(0.7)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        Color.gray.opacity(0.4)
                    }
                }
            )
            .foregroundColor(.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black.opacity(0.3), lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .disabled(!vm.isFormValid || vm.isLoading)
        .animation(.easeInOut, value: vm.isFormValid)
    }
    
    private var footerSection: some View {
        HStack(spacing: 4) {
            Text("¿Ya tienes cuenta?")
                .foregroundColor(.black.opacity(0.7))
            
            Button(action: {
                dismiss()
            }) {
                Text("Inicia sesión")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .shadow(color: .white.opacity(0.5), radius: 1, x: 0, y: 0)
            }
        }
        .font(.subheadline)
    }
}

#Preview {
    SignUpView()
}

