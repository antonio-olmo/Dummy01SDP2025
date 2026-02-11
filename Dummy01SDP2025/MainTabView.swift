//
//  MainTabView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 16/12/25.
//

import SwiftUI

/*struct MainTabView: View {
    var body: some View {
        
        TabView {
            Tab("Mangas", systemImage: "book") {
                ContentView()
            }
            Tab ("Listas", systemImage: "list.bullet.rectangle.portrait.fill"){
                ListsView()
            }
            Tab ("Colección", systemImage: "books.vertical.fill"){
                CollectionView()
            }
            Tab ("Mi cuenta", systemImage: "person.crop.circle"){
                MyAccountView()
            }
            Tab("Buscar", systemImage: "magnifyingglass", role: .search) {
                SearchView()
            }
        }
    }
}

#Preview {
    MainTabView()
}*/

struct MainTabView: View {
    
    @State var vm = MainTabVM()
    
    var body: some View {
        TabView(selection: $vm.selectedTab) {
            Tab("Mangas", systemImage: "book", value: 0) {
                NavigationStack(path: $vm.mangasPath) {
                    ContentView()
                }
            }
            Tab("Listas", systemImage: "list.bullet.rectangle.portrait.fill", value: 1) {
                NavigationStack(path: $vm.listsPath) {
                    ListsView()
                }
            }
            Tab("Colección", systemImage: "books.vertical.fill", value: 2) {
                NavigationStack(path: $vm.collectionPath) {
                    CollectionView()
                }
            }
            Tab("Mi cuenta", systemImage: "person.crop.circle", value: 3) {
                NavigationStack(path: $vm.accountPath) {
                    MyAccountView()
                }
            }
            Tab("Buscar", systemImage: "magnifyingglass", value: 4, role: .search) {
                NavigationStack(path: $vm.searchPath) {
                    SearchView()
                }
            }
        }
        .onChange(of: vm.selectedTab) { oldValue, newValue in
            // Resetear el path de la tab anterior cuando cambias de tab
            switch oldValue {
            case 0: vm.mangasPath = NavigationPath()
            case 1:
                if vm.listsPath.count == 2 {
                    vm.listsPath.removeLast()
                }
            case 2: vm.collectionPath = NavigationPath()
            case 3: vm.accountPath = NavigationPath()
            case 4: vm.searchPath = NavigationPath()
            default: break
            }
        }
    }
}

#Preview {
    MainTabView()
}
