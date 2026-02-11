//
//  AddMangaView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 8/1/26.
//

//
//  AddMangaView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 8/1/26.
//

import SwiftUI
import SwiftData

/*struct FavouriteMangaView: View {
    
    //@FocusState private var isTextFieldFocused: Bool
    
    @Environment(\.dismiss) private var dismiss
    @Query var mangas: [MangaData]
        
    var body: some View {
            
        //NavigationStack {
            
            ScrollView {
                VStack (alignment: .leading) {
                    ForEach(mangas) { favouriteManga in
                        VStack {
                            Text(favouriteManga.title)
                            Text("\(favouriteManga.id)")
                                .font(.footnote)
                        }
                    }
                }
            }
            .safeAreaPadding()
            .navigationTitle("Tu colección de Mangas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("cerrar") {
                        dismiss()
                    }
                }
            }
        //}
    }
}



#Preview {
    let userCollection = UserCollection(
        id: "",
        manga: Manga.testMangas[0],
        volumesOwned: [],
        completeCollection: false,
        readingVolume: 0
    )
    let detailVM = AddMangaVM(mangaCollection: userCollection)
    AddMangaView(vm: detailVM, reload: .constant(false))
}*/

struct FavouriteMangaView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Query var mangas: [MangaData]
    
    @State private var currentIndex: Int = 0
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 30) {
                        ForEach(mangas) { favouriteManga in
                            
                            MangaCardView(manga: favouriteManga, size: geometry.size)
                                .containerRelativeFrame(.horizontal)
                                .scrollTransition { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1.0 : 0.7)
                                        .scaleEffect(phase.isIdentity ? 1.0 : 0.85)
                                        .rotation3DEffect(
                                            .degrees(phase.value * 15),
                                            axis: (x: 0, y: 1, z: 0)
                                        )
                                }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .contentMargins(.horizontal, 40, for: .scrollContent)
            }
            .navigationTitle("Premiere (Favoritos)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
        .presentationBackground {
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.95, blue: 0.85),    // Durazno claro
                    Color(red: 0.85, green: 0.75, blue: 0.95),   // Lavanda
                    Color(red: 0.70, green: 0.85, blue: 1.0)     // Azul cielo
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}


struct MangaCardView: View {
    let manga: MangaData
    let size: CGSize
    
    var body: some View {
        ZStack(alignment: .center) {
            // Imagen de fondo del manga
            MangaCoverView(urlString: manga.mainPicture ?? "", standarHeight: size.height * 0.68)
                //.frame(height: size.height * 2.5 )
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            // Overlay oscuro para mejor legibilidad
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.3),
                            Color.black.opacity(0.5),
                            Color.black.opacity(0.7)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size.width * 0.9)
            
            // Título en el centro
            VStack(spacing: 12) {
                Spacer()
                
                Text(manga.title)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    )
                
                if let englishTitle = manga.titleEnglish {
                    Text(englishTitle)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial.opacity(0.8))
                        )
                }
                
                Spacer()
            }
        }
        .frame(height: size.height * 0.8)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.6),
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
    }
}



#Preview {
    //FavouriteMangaView(mangas: MangaData.testMangas[0])
}

