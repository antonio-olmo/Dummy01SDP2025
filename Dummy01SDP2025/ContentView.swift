//
//  ContentView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 14/12/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var vm = MangasVM()
    
    var body: some View {
            
        NavigationStack {
            
            ScrollView {
                VStack (alignment: .leading) {
                    ForEach(vm.mangas) { manga in
                        NavigationLink(value: manga) {
                            MangaRow(manga: manga)
                        }
                    }
                }
            }
            .safeAreaPadding()
            .navigationTitle("Mangas para ti ...")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Manga.self) { manga in
                MangaDetailView(manga: manga)
            }
            .buttonStyle(.plain)
            /*.navigationDestination(for: Manga.self) { manga in
             BookView(book: manga, namespace: namespace)
             }
             .toolbar {
             ToolbarItem(placement: .principal) {
             Text("Books")
             .font(.title3)
             .bold()
             }
             }
             .toolbarRole(.editor)*/            
        }
        /*.task(priority: .high) {
            await vm.getMangas()
        }*/
        .refreshable {
            
            vm.loadInitMangas()
            
        }
    }
}

#Preview {
    ContentView()
}
