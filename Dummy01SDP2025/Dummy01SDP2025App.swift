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
    @State private var vm = MainVM()
        
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Vista según el estado de autenticación
                Group {
                    if vm.isInitializing {
                        // Verificación inicial al abrir la app
                        LoadingView()
                    } else if vm.isAuthenticated {
                        // Usuario logueado - Mostrar view principal
                        MainTabView()
                    } else {
                        SignInView()
                            .environment(vm)
                    }
                }
                
                // Overlay de verificación cuando vuelve del background
                if vm.isVerifying {
                    LoadingView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: vm.isVerifying)
            .task {
                // Verificación inicial al lanzar la app
                await vm.checkInitialAuthentication()
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .active:
                print("Estamos en Fore !!!")
                // Solo verificar si ya terminó la inicialización
                if !vm.isInitializing {
                    vm.onAppEnterForeground()
                }
            case .inactive:
                print("App en estado INACTIVE")
            case .background:
                print("Estamos en Back !!!")
            default:
                break
            }
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

