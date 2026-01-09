//
//  MainTabView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 16/12/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        
        TabView {
            Tab("Mangas", systemImage: "book") {
                ContentView()
            }
            Tab ("Listas", systemImage: "heart"){
                ListsView()
            }
            Tab ("Mi cuenta", systemImage: "heart"){
                MyAccountView()
            }
            Tab ("Colección", systemImage: "heart"){
                CollectionView()
            }
            Tab("Buscar", systemImage: "magnifyingglass", role: .search) {
                SearchView()
            }
        }
    }
}

#Preview {
    MainTabView()
}
