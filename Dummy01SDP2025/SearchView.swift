//
//  SearchView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 16/12/25.
//

import SwiftUI

struct SearchView: View {
    
    //@State private var searchTask: Task<Void, Never>?
    @State private var vm = SearchVM()
    
    var body: some View {
        //NavigationStack {
            VStack {
                /*Text("Búsquedas")
                    .font(.headline)*/
                if vm.mangaResult.isEmpty {
                    searchView                    
                } else {
                    /*List(vm.mangaResult) { manga in
                        Text(manga.title)
                    }*/
                    ScrollView {
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
            /*.onChange(of: vm.search) {
                if vm.search.count > 2 {
                    
                    if vm.searchComplete {
                        vm.searchComplete = false
                        vm.page = 0
                        vm.mangaResult = []
                        Task {
                            print("Inicio búsqueda")
                            vm.busqueda == .title ? await vm.findBooks() : await vm.findAuthors()
                            print("Fin búsqueda")
                            vm.searchComplete = true
                        }
                    } else {
                        print("no procede ...")
                    }
                } else {
                    vm.mangaResult = []
                }
            }*/
            .onChange(of: vm.search) {
                
                vm.searching()
                
                /*if vm.search.count > 2 {
                    
                    //if vm.searchComplete {
                        vm.searchComplete = false
                        vm.page = 0
                        vm.mangaResult = []
                        
                        // Cancelar la búsqueda pendiente si existe
                        searchTask?.cancel()
                        
                        // Crear nueva tarea con delay de 300ms
                        searchTask = Task {
                            do {
                                try await Task.sleep(for: .milliseconds(300))
                                
                                // Verificar si la tarea no fue cancelada
                                guard !Task.isCancelled else { return }
                                
                                print("Inicio búsqueda")
                                vm.busqueda == .title ? await vm.findBooks() : await vm.findAuthors()
                                print("Fin búsqueda")
                                vm.searchComplete = true
                            } catch {
                                // Task fue cancelada o hubo error en sleep
                                print("Búsqueda cancelada")
                                vm.searchComplete = true
                            }
                        }
                    //}
                } else {
                    // Cancelar cualquier búsqueda pendiente cuando hay menos de 3 caracteres
                    searchTask?.cancel()
                    vm.searchComplete = true
                    vm.mangaResult = []
                }*/
            }
        //}
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
                            .frame(height:200)
                            .foregroundStyle(.secondary)
                    }
                } description: {
                }
                
            } else if vm.search.isEmpty {
                ContentUnavailableView {
                    Label {
                        Text("¿Qué busco?")
                            .font(.title2)
                            .fontWeight(.semibold)
                    } icon: {
                        Image(.search)
                            .resizable()
                            .scaledToFit()
                            .frame(height:200)
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
                            .frame(height:200)
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
                
            } else if !vm.search.isEmpty {
                
                ContentUnavailableView {
                    Label {
                        Text("Lo siento ...")
                            .font(.title2)
                            .fontWeight(.semibold)
                    } icon: {
                        Image(.noFound)
                            .resizable()
                            .scaledToFit()
                            .frame(height:200)
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
            }
        }
    }
}

#Preview {
    SearchView()
}
