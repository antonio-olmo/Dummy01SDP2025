//
//  CollectionView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 6/1/26.
//

import SwiftUI

struct CollectionView: View {
    
    @State var vm = CollectionVM()
    @State private var showFavourites = false
    
    var body: some View {
        
        //NavigationStack {
            
            ScrollView {
                VStack (alignment: .leading) {
                    ForEach(vm.userCollection) { userCollection in
                        NavigationLink(value: userCollection.manga) {
                            MangaRow(manga: userCollection.manga)
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
            .buttonStyle(.plain)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        showFavourites.toggle()
                    } label: {
                        Image(systemName: "star.fill")
                    }
                    
                    
                }
            }
            .sheet(isPresented: $showFavourites) {
                FavouriteMangaView()
            }
            
             
        //}
        .onAppear {
            //if !vm.dataLoaded {
                vm.loadInitMangas()
            //}
        }
    }
}

#Preview {
    CollectionView()
}
