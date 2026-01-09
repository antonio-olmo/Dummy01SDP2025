//
//  MangaThemeRow.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 21/12/25.
//

import SwiftUI

struct MangaListRow: View {
    
    let list: String
    let listsDictionary : [String:[Manga]]
    
    private var stringTitles: String {
        guard let mangas = listsDictionary[list] else { return "" }
        let titles = mangas.map { $0.title }.joined(separator: ", ")
        return titles.isEmpty ? "" : "\(titles), ..."
    }
    
    var body: some View {
        
        VStack (alignment: .leading) {
            
            Text(list)
                .font(.title)
                .bold()
            
            if let mangas = listsDictionary[list] {
                
                Text(stringTitles)
                    .font(.subheadline)
                    .opacity(0.6)
                    .lineLimit(2)
                
                HStack {
                    Spacer()
                    ForEach(mangas) { manga in
                        //MangaCoverView(manga: manga)
                        MangaCoverView(urlString: manga.mainPicture ?? "")
                    }
                    Spacer()
                }
                
                //.safeAreaPadding()
            }
            
        }
        .padding()
        .background(.orange.opacity(0.1), in: .rect(cornerRadius: 35))
    }
    
    /*struct MangaCoverView: View {
        let manga: Manga
        @State private var vm = CoverVM()
        
        var body: some View {
            Group {
                
                if let image = vm.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 140)
                        .clipShape(Rectangle())
                } else {
                    placeholder
                }
                
            }
            .onAppear {
                vm.getImage(cover: URL(string: .getStringMainPicture(mainPicture: manga.mainPicture)))
            }
        }
        
        private var placeholder: some View {
            Image(systemName: "apple.books.pages.fill")
                .font(.largeTitle)
                .frame(width: 90, height: 140)
                //.clipShape(.circle)
                .background(.gray.opacity(0.3), in: .rect(cornerRadius: 11))
                //.background(.red.opacity(0.1), in: .circle)
        }
    }*/
    
    struct MangaCoverView: View {
        let urlString: String
        @State private var vm = CoverVM()
        
        var body: some View {
            Group {
                
                if let image = vm.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 140)
                        .clipShape(Rectangle())
                } else {
                    placeholder
                }
                
            }
            .onAppear {
                vm.getImage(cover: URL(string: .getStringMainPicture(mainPicture: urlString)))
            }
        }
        
        private var placeholder: some View {
            Image(systemName: "apple.books.pages.fill")
                .font(.largeTitle)
                .frame(width: 90, height: 140)
                //.clipShape(.circle)
                .background(.gray.opacity(0.3), in: .rect(cornerRadius: 11))
                //.background(.red.opacity(0.1), in: .circle)
        }
    }
}

#Preview {
    MangaListRow(list: "Survival", listsDictionary: Manga.testMangaTheme)
}
