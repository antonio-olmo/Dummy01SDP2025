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
    
    @AppStorage("nickName") var nickName: String = ""
    
    @Environment(\.dismiss) private var dismiss
    //@Query var mangas: [MangaData]
    @Query(sort: \MangaData.title, order: .forward) var mangas: [MangaData]
    @State var vm = FavouriteMangaVM()
    
    @State private var isLoading = false
    @State private var navigateToDetail = false
    
    @Binding var reload: Bool
    
    var body: some View {
            
            GeometryReader { geometry in
                
                if mangas.count > 0 {
                
                    HStack (alignment: .center) {
                        Image(.standard)
                            .resizable()
                            .scaledToFit()
                            .frame(height:60)
                        VStack {
                            Text("Estos son tus mangas favoritos")
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            Text("Puedes añadirlos a tu colección ...")
                                .font(.footnote)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: isiPhone ? 16 : -55) {
                            ForEach(mangas) { favouriteManga in
                                
                                Button {
                                    Task {
                                        isLoading = true
                                        await vm.getManga(favouriteManga.id)
                                        isLoading = false
                                        //if vm.manga != nil {
                                        if let _ = vm.manga {
                                            navigateToDetail = true
                                        }
                                    }
                                } label: {
                                    MangaCardView(manga: favouriteManga, size: geometry.size)
                                }
                                .disabled(isLoading)
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
                    .overlay {
                        if isLoading {
                            ZStack {
                                Color.black.opacity(0.3)
                                    .ignoresSafeArea()
                                
                                ProgressView("Cargando manga...")
                                    .padding()
                                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                            }
                        }
                    }
                    
                } else {
                    ContentUnavailableView {
                        Label {                            
                            
                            Text(nickName == "" ? "¿Aún no tienes favoritos?" : "\(nickName)\n¿Aún no tienes favoritos?")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                        } icon: {
                            Image(.standard)
                                .resizable()
                                .scaledToFit()
                                .frame(height:200)
                                .foregroundStyle(.secondary)
                        }
                    } description: {
                        
                        VStack {
                            Text("Busca, busca, y añade algunos ...")
                                .foregroundStyle(.secondary)
                            Text("No se grabarán en tu colección")
                                .foregroundStyle(.secondary)
                                .fontWeight(.semibold)
                            Divider().padding(.horizontal)
                            
                            
                        }
                        .padding(.horizontal)
                        
                    }
                }
            }
            .navigationTitle("Premiere (Favoritos)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $navigateToDetail) {
                if let manga = vm.manga {
                    MangaDetailView(manga: manga)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        reload.toggle()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.gray.opacity(0.6))
                    
                }
            }
            
        
    }
}


struct MangaCardView: View {
    let manga: MangaData
    let size: CGSize
    
    var body: some View {
        ZStack(alignment: .center) {
            // Imagen de fondo del manga 0.62
            MangaCoverView(urlString: manga.mainPicture ?? "", standarHeight: isiPhone ? size.height * 0.62 : size.height * 0.72)
                //.frame(height: size.height * 2.5 )
                //.clipped()
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            // Overlay oscuro para mejor legibilidad
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.6),
                            Color.black.opacity(0.3),
                            Color.black.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 4
                )
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
                .frame(width: size.width * 0.86, height: isiPhone ? size.height * 0.7 : size.height * 0.8)
            
            
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
                
                /*if let englishTitle = manga.titleEnglish {
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
                }*/
                
                Spacer()
            }
        }
        .frame(height: size.height)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
    }
}



#Preview {
    //FavouriteMangaView(mangas: MangaData.testMangas[0])
}

