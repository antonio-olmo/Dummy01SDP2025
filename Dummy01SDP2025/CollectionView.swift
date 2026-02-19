//
//  CollectionView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 6/1/26.
//

import SwiftUI

struct CollectionView: View {
    
    @AppStorage("nickName") var nickName: String = ""
    @State var vm = CollectionVM()
    @State private var navigateToFavourites = false
    
    @State private var reload = false
    
    let itemManga: [GridItem] = [GridItem(.adaptive(minimum: 300))]
    
    var body: some View {
        
        if vm.userCollection.count == 0 {
            ContentUnavailableView {
                Label {
                    
                    Text(nickName == "" ? "Tu colección está vacía" : "\(nickName)\nTu colección está vacía")
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
                    Text("Añade los mangas que tengas")
                        .foregroundStyle(.secondary)
                    Text("Se grabarán en la nube")
                        .foregroundStyle(.secondary)
                        .fontWeight(.semibold)
                    Divider().padding(.horizontal)
                    
                    
                }
                .padding(.horizontal)
                
            }
            .safeAreaPadding()
            .navigationTitle("Tu colección de Mangas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        navigateToFavourites.toggle()
                    } label: {
                        Image(systemName: "star.fill")
                    }
                    
                    
                }
            }
            .fullScreenCover(isPresented: $navigateToFavourites) {
                NavigationStack {
                    FavouriteMangaView(reload: $reload)
                        
                }
            }
            .onAppear {
                //if !vm.dataLoaded {
                    vm.loadInitMangas()
                //}
            }
            .onChange(of: reload) { oldValue, newValue in
                if newValue {
                    print("RELOAD ...")
                    vm.loadInitMangas()
                    reload.toggle()
                }
            }
        } else {
            
            ScrollView {
                
                if isiPhone {
                    
                    VStack (alignment: .leading) {
                        ForEach(vm.userCollection) { userCollection in
                            NavigationLink(value: userCollection.manga) {
                                MangaRow(manga: userCollection.manga)
                            }
                        }
                    }
                    
                } else {
                    LazyVGrid(columns: itemManga) {
                        ForEach(vm.userCollection) { userCollection in
                            NavigationLink(value: userCollection.manga) {
                                MangaRow(manga: userCollection.manga)
                            }
                        }
                    }
                }
            }
            .safeAreaPadding()
            .navigationTitle("Tu colección de Mangas")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Manga.self) { manga in
                MangaDetailView(manga: manga)
            }
            /*.navigationDestination(for: MangaData.self) { mangaData in
                Text(mangaData.title)
            }
            .navigationDestination(isPresented: $navigateToFavourites) {
                FavouriteMangaView()
            }*/
            
            .buttonStyle(.plain)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        navigateToFavourites.toggle()
                    } label: {
                        Image(systemName: "star.fill")
                    }
                    
                    
                }
            }
            .fullScreenCover(isPresented: $navigateToFavourites) {
                NavigationStack {
                    FavouriteMangaView(reload: $reload)
                        
                }
            }
            .onAppear {
                //if !vm.dataLoaded {
                    vm.loadInitMangas()
                //}
            }
            .onChange(of: reload) { oldValue, newValue in
                if newValue {
                    print("RELOAD ...")
                    vm.loadInitMangas()
                    reload.toggle()
                }
            }
            
             
        }
        
    }
}

#Preview {
    CollectionView()
}
