//
//  MangaRow.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 22/12/25.
//

import SwiftUI

struct MangaRow: View {
    
    let manga: Manga
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("\(manga.title) - \(manga.authors.count)")
                .font(.headline)
            //Text(String.getStringMainPicture(mainPicture: manga.mainPicture))
            AsyncImage(url: URL(string: .getStringMainPicture(mainPicture: manga.mainPicture))) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75)
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .padding()
                    .background(.gray.opacity(0.1), in: .circle)
            }
            HStack (alignment: .top) {
                VStack (alignment: .leading) {
                    ForEach (manga.genres, id: \.self) { genre in
                        
                        Text(genre)
                            .font(.footnote)
                    }
                }
                
                Spacer()
                
                VStack (alignment: .trailing) {
                    ForEach (manga.authors) { author in
                        
                        Text(author.lastName)
                            .font(.footnote)
                    }
                }
            }
        }
        Divider()
    }
}

#Preview {
    MangaRow(manga: Manga.testMangas[0])
}
