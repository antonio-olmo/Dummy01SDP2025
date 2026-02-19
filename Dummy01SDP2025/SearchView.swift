//
//  SearchView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 16/12/25.
//

import SwiftUI

struct SearchView: View {
    
    @AppStorage("nickName") var nickName: String = ""
    
    //@State private var searchTask: Task<Void, Never>?
    @State private var vm = SearchVM()
    
    let itemManga: [GridItem] = [GridItem(.adaptive(minimum: 300))]
    
    var body: some View {
        
        VStack {
            
            if vm.mangaResult.isEmpty {
                searchView
            } else {
                ScrollView {
                    
                    if isiPhone {
                        
                        LazyVStack (alignment: .leading) {
                            ForEach(vm.mangaResult) { manga in
                                NavigationLink(value: manga) {
                                    MangaRow(manga: manga)
                                }
                            }
                            if vm.mangaResult.count > 1 && vm.searchComplete && !vm.lastSearch {
                                HStack {
                                    ProgressView()
                                        .onAppear {
                                            Task {
                                                vm.busqueda == .title ? await vm.findBooks() : await vm.findAuthors()
                                            }
                                        }
                                    Text("cargando mangas ...")
                                        .font(.footnote)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        
                    } else {
                        
                        LazyVGrid(columns: itemManga) {
                            ForEach(vm.mangaResult) { manga in
                                NavigationLink(value: manga) {
                                    MangaRow(manga: manga)
                                }
                            }
                            if vm.mangaResult.count > 1 && vm.searchComplete && !vm.lastSearch {
                                HStack {
                                    ProgressView()
                                        .onAppear {
                                            Task {
                                                vm.busqueda == .title ? await vm.findBooks() : await vm.findAuthors()
                                            }
                                        }
                                    Text("cargando mangas ...")
                                        .font(.footnote)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
                .safeAreaPadding()
                .buttonStyle(.plain)
            }
        }
        
        .navigationTitle("Busca por título o autor")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Manga.self) { manga in
            MangaDetailView(manga: manga)
        }
        .searchable(text: $vm.search, prompt: vm.busqueda == .title ? "Busca por el título" : "Busca por el autor")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Menu {
                    ForEach(TipoBusqueda.allCases) { busqueda in
                        Button {
                            vm.busqueda = busqueda
                        } label: {
                            HStack {
                                Text(busqueda.rawValue)
                                if vm.busqueda == busqueda {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Label("Búsqueda", systemImage: "square.stack.fill")
                }
            }
        }
        .onChange(of: vm.search) {
            vm.searching()
        }
        
    }
    
    var searchView: some View {
        VStack {
            
            if !vm.searchComplete {
                
                ContentUnavailableView {
                    Label {
                        HStack {
                            ProgressView()
                            Text("Buscando ...")
                                .font(.footnote)
                                //.fontWeight(.semibold)
                        }
                    } icon: {
                        Image(.searching)
                            .resizable()
                            .scaledToFit()
                            .frame(height: isiPhone ? 200 : 300)
                            .foregroundStyle(.secondary)
                    }
                } description: {
                }
                .padding(.horizontal, isiPhone ? 0 : 100)
                
            } else if vm.search.isEmpty {
                ContentUnavailableView {
                    Label {
                        Text(nickName == "" ? "¿Qué busco?" : "\(nickName)\n¿Qué buscas?")
                            .font(.title2)
                            .fontWeight(.semibold)
                    } icon: {
                        Image(.search)
                            .resizable()
                            .scaledToFit()
                            .frame(height: isiPhone ? 200 : 300)
                            .foregroundStyle(.secondary)
                    }
                } description: {
                    
                    VStack {
                        Text("Escribe un texto para buscar mangas")
                            .foregroundStyle(.secondary)
                        Divider().padding(.horizontal)
                        
                        Toggle("Que contenga el texto", isOn: $vm.searchContains)
                        Text("Desmarca para que empiece por el texto")
                            .font(.footnote)
                    }
                    .padding(.horizontal)
                    
                }
                .padding(.horizontal, isiPhone ? 0 : 100)
                
            } else if vm.search.count <= 2 {
                
                ContentUnavailableView {
                    Label {
                        Text("Un poco mas ...")
                            .font(.title2)
                            .fontWeight(.semibold)
                    } icon: {
                        Image(.three)
                            .resizable()
                            .scaledToFit()
                            .frame(height: isiPhone ? 200 : 300)
                            .foregroundStyle(.secondary)
                    }
                } description: {
                                        
                    VStack {
                        Text("Escribe al menos 3 caracteres")
                            .foregroundStyle(.secondary)
                        Divider().padding(.horizontal)
                        
                        Toggle("Que contenga el texto", isOn: $vm.searchContains)
                        Text("Desmarca para que empiece por el texto")
                            .font(.footnote)
                    }
                    .padding(.horizontal)
                    
                }
                .padding(.horizontal, isiPhone ? 0 : 100)
                
            } else if !vm.search.isEmpty {
                
                ContentUnavailableView {
                    Label {
                        Text(nickName == "" ? "Lo siento ..." : "Lo siento, \(nickName) ... ")
                            .font(.title2)
                            .fontWeight(.semibold)
                    } icon: {
                        Image(.noFound)
                            .resizable()
                            .scaledToFit()
                            .frame(height: isiPhone ? 200 : 300)
                            .foregroundStyle(.secondary)
                    }
                } description: {
                                        
                    VStack {
                        Text("¡No he encontrado nada!")
                            .foregroundStyle(.secondary)
                        Divider().padding(.horizontal)
                        
                        Toggle("Que contenga el texto", isOn: $vm.searchContains)
                        Text("Desmarca para que empiece por el texto")
                            .font(.footnote)
                    }
                    .padding(.horizontal)
                    
                }
                .padding(.horizontal, isiPhone ? 0 : 100)
    
            }
        }
    }
}

#Preview {
    SearchView()
}
