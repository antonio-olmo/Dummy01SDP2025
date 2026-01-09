//
//  MangasByThemeView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 22/12/25.
//

import SwiftUI

struct MangasByListView: View {
    
    //@State var vm: MangasByThemeVM
    @State var vm: MangasByListVM
    
    var body: some View {
        
            ScrollView {
                LazyVStack (alignment: .center) {
                    
                    
                    
                    if let mangas = vm.itemDictionary[vm.item] {
                        ForEach(mangas) { manga in
                            NavigationLink(value: manga) {
                                MangaRow(manga: manga)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    
                }
            }
            .scrollIndicators(.hidden)
            .safeAreaPadding()
            .padding(.horizontal)
            .navigationTitle("Mangas de \(vm.item)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Manga.self) { manga in
                MangaDetailView(manga: manga)
            }
        
    }
}

/*#Preview {
    MangasByThemeView(vm: MangasByThemeVM(theme: "Survival", themeDictionary: Manga.testMangaTheme, randomPage: 1))
}*/
