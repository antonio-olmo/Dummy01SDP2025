//
//  Dummy01SDP2025App.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 14/12/25.
//

//
//  Dummy01SDP2025App.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 14/12/25.
//

import SwiftUI

@main
struct Dummy01SDP2025App: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    var isVerifying = false
    var isAuthenticated = false
    @State private var isInitializing = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Vista según el estado de autenticación
                Group {
                    if isInitializing {
                        // Verificación inicial al abrir la app
                        LoadingView()
                    } else if isAuthenticated {
                        // Usuario logueado - Mostrar app principal
                        MainTabView()
                    } else {
                        // Sin login - Mostrar pantalla de login
                        SignInView()
                    }
                }
                
                // Overlay de verificación cuando vuelve del background
                if isVerifying {
                    LoadingView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: isVerifying)
            .task {
                // Verificación inicial al lanzar la app
                await checkInitialAuthentication()
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .active:
                print("🟢 App en FOREGROUND (active)")
                // Solo verificar si ya terminó la inicialización
                if !isInitializing {
                    onAppEnterForeground()
                }
            case .inactive:
                print("🟡 App INACTIVE")
            case .background:
                print("🔴 App en BACKGROUND")
            @unknown default:
                break
            }
        }
    }
    
    /// Verificación inicial al abrir la app
    private func checkInitialAuthentication() async {
        print("🚀 Verificación inicial al abrir la app...")
        
        do {
            // Intentar obtener el token del Keychain
            let token = try KeychainManager.shared.getAuthToken()
            print("🔑 Token encontrado en Keychain")
            
            // Validar con la API
            /*let repository = Network()
            let isValid = try await repository.validateToken(token: token)*/
            let isValid = true
            
            if isValid {
                print("✅ Token válido - Usuario autenticado")
                isAuthenticated = true
            } else {
                print("⚠️ Token inválido - Requiere login")
                try KeychainManager.shared.deleteAuthToken()
                isAuthenticated = false
            }
            
        } catch KeychainManager.KeychainError.itemNotFound {
            print("ℹ️ No hay token guardado - Mostrar login")
            isAuthenticated = false
        } catch {
            print("❌ Error en verificación inicial: \(error.localizedDescription)")
            isAuthenticated = false
        }
        
        // Finalizar inicialización
        isInitializing = false
    }
    
    /// Verificación al volver del background
    private func onAppEnterForeground() {
        print("🚀 App vuelve a foreground - Verificando sesión...")
        
        // Solo verificar si el usuario está autenticado
        guard isAuthenticated else {
            print("ℹ️ Usuario no autenticado, no se verifica")
            return
        }
        
        // ✅ Mostrar loading inmediatamente
        isVerifying = true
        
        // ✅ Usar Task para operaciones asíncronas (NO bloquea la UI)
        Task {
            do {
                // Obtener el token del Keychain
                let token = try KeychainManager.shared.getAuthToken()
                print("🔑 Validando token con API...")
                
                
                
                // Validar el token con la API
                /*let repository = Network()
                let isValid = try await repository.validateToken(token: token)*/
                let isValid = true
                
                if isValid {
                    print("✅ Token válido - Sesión activa")
                } else {
                    print("⚠️ Token inválido - Cerrando sesión")
                    try KeychainManager.shared.deleteAuthToken()
                    isAuthenticated = false
                }
                
            } catch {
                print("❌ Error al verificar token: \(error.localizedDescription)")
                // Si hay error, cerrar sesión por seguridad
                isAuthenticated = false
            }
            
            // Esperar un momento para que se vea la animación (opcional)
            try? await Task.sleep(for: .milliseconds(500))
            
            // ✅ Ocultar loading
            isVerifying = false
            print("✅ Verificación completada")
        }
    }
    
    struct LoadingView: View {
        var body: some View {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                    
                    Text("Verificando sesión...")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

