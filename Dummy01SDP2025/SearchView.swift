//
//  SearchView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 16/12/25.
//

import SwiftUI

struct SearchView: View {
    @State private var vm = SearchVM()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Búsquedas")
                    .font(.headline)
                if vm.mangaResult.isEmpty {
                    searchView
                } else {
                    List(vm.mangaResult) { manga in
                        Text(manga.title)
                    }
                }
            }
            .searchable(text: $vm.search, prompt: "Enter the search a book")
            .onChange(of: vm.search) {
                if vm.search.count >= 3 {
                    Task {
                        await vm.findBooks()
                    }
                } else {
                    vm.mangaResult = []
                }
            }
            .onAppear {
                vm.initSearch()
            }
            
        }
    }
    
    var searchView: some View {
        VStack {
            
            Button {
                
            } label: {
                Text("Empieza por ...")
            }
            .buttonStyle(.plain)
            //.padding()
            
            if vm.search.isEmpty {
                ContentUnavailableView("No search",
                                       systemImage: "magnifyingglass.circle",
                                       description:
                                        Text("Type at least 3 characters to find any book by its title at the database."))
            } else if vm.search.count <= 3 {
                ContentUnavailableView("Keep swimming",
                                       systemImage: "keyboard",
                                       description: Text("Type at least 3 characters to search."))
                
            } else if !vm.search.isEmpty {
                ContentUnavailableView("No book found",
                                       systemImage: "books.vertical.fill",
                                       description: Text("There's no book at the database with your search criteria."))
            }
        }
    }
}

#Preview {
    SearchView()
}
