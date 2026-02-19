//
//  ContentView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 14/12/25.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("nickName") var nickName: String = ""
    
    @State var vm = MangasVM()
    
    let itemManga: [GridItem] = [GridItem(.adaptive(minimum: 300))]
    
    var body: some View {
        
        ScrollView {
            
            if isiPhone {
                
                LazyVStack {
                    ForEach(vm.mangas) { manga in
                        NavigationLink(value: manga) {
                            MangaRow(manga: manga)
                        }
                    }
                }
                
            } else {
                
                LazyVGrid(columns: itemManga) {
                    ForEach(vm.mangas) { manga in
                        NavigationLink(value: manga) {
                            MangaRow(manga: manga)
                        }
                    }
                }
            }
        }
        .refreshable {
            
            vm.loadInitMangas()
            
        }
        .safeAreaPadding()
        .navigationTitle(nickName == "" ? "Mangas para ti ..." : "Mangas para \(nickName)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Manga.self) { manga in
            MangaDetailView(manga: manga)
        }
        .buttonStyle(.plain)
            
        .onAppear {
            if !vm.dataLoaded {
                vm.loadInitMangas()
            }
        }
    }
}

#Preview {
    ContentView()
}
