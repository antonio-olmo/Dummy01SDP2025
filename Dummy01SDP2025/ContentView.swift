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
            
        //NavigationStack {
            
            ScrollView {
                LazyVStack  {
                    ForEach(vm.mangas) { manga in
                        NavigationLink(value: manga) {
                            MangaRow(manga: manga)
                        }
                    }
                }
            }
            .refreshable {
                
                vm.loadInitMangas()
                
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
        //}
        .onAppear {
            if !vm.dataLoaded {
                vm.loadInitMangas()
            }
        }
        /*.task(priority: .high) {
            await vm.getMangas()
        }*/
        
    }
}

#Preview {
    ContentView()
}
