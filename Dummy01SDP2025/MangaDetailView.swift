//
//  MangaDetailView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 28/12/25.
//

import SwiftUI

struct MangaDetailView: View {
    
    @State private var showAddManga = false
    
    let manga: Manga
    @State var vm = CoverVM()
    
    var body: some View {
    
        GeometryReader { geometry in
            ScrollView {
                ZStack(alignment: .top) {
                    // Fondo con imagen estática en B&N con zoom
                    if let image = vm.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .scaleEffect(1.3) // Zoom potente
                            .frame(width: geometry.size.width, height: 492)
                            .clipped()
                            .grayscale(1.0) // Blanco y negro
                            .blur(radius: 3, opaque: true) // Ligero blur para efecto dramático
                            .overlay(
                                
                                // Degradado de blanco a transparente más suave
                                LinearGradient(
                                    stops: [
                                        .init(color: .white.opacity(1), location: 0.0),
                                        .init(color: .white.opacity(0.9), location: 0.15),
                                        .init(color: .white.opacity(0.7), location: 0.3),
                                        .init(color: .white.opacity(0.4), location: 0.5),
                                        .init(color: .white.opacity(0.1), location: 0.65),
                                        .init(color: .clear, location: 0.8),
                                        .init(color: .white.opacity(0.5), location: 0.9),
                                        .init(color: Color(white: 1), location: 1)
                                        
                                        
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                
                                
                            )
                            .ignoresSafeArea(edges: .top)
                                                        
                    }
                    
                    // Contenido principal
                    VStack(spacing: 20) {
                        Spacer()
                            .frame(height: 3)
                        
                        // Imagen animada principal
                        //AnimatedZoomImageView(urlString: manga.mainPicture ?? "")
                        AnimatedZoomImageView(image: vm.image)
                            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                        
                        
                        // Título y contenido adicional con más espacio
                        VStack(spacing: 12) {
                            Text(manga.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .padding(.top, 20) // Más separación desde la imagen
                            
                            // Aquí puedes añadir más información del manga
                            Text("Más información del manga...")
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 50)
                        }
                    }
                }
                
                
            }
            .scrollIndicators(.hidden)
            .navigationTitle(manga.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Button {
                        showAddManga.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                    
                }
            }
            .sheet(isPresented: $showAddManga) {
                AddMangaView()
            }
            .onAppear {
                vm.getImage(cover: URL(string: .getStringMainPicture(mainPicture: manga.mainPicture ?? "")))
            }
            
        }
        
    }
    
    struct AnimatedZoomImageView: View {
        //let urlString: String
        let image: UIImage?
        
        @State private var vm = CoverVM()
        @State private var scale: CGFloat = 1.0
        
        var body: some View {
            Group {
                //if let image = vm.image {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(scale)
                        .frame(width: 300, height: 450)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.6),
                                            Color.white.opacity(0.3),
                                            Color.purple.opacity(0.4),
                                            Color.blue.opacity(0.5)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(color: Color(red: 0.3, green: 0.2, blue: 0.5).opacity(0.7), radius: 20, x: 0, y: 10)
                        .shadow(color: .black.opacity(0.5), radius: 30, x: 0, y: 15)
                        //.shadow(color: .purple.opacity(0.3), radius: 40, x: 0, y: 20)
                } else {
                    placeholder
                }
            }
            .frame(width: 300, height: 450)
            .onAppear {
                //vm.getImage(cover: URL(string: .getStringMainPicture(mainPicture: urlString)))
                startBreathingAnimation()
            }
        }
        
        private var placeholder: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Image(systemName: "apple.books.pages.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.secondary.opacity(0.5))
            }
            .frame(width: 300, height: 450)
        }
        
        private func startBreathingAnimation() {
            // Delay inicial antes de empezar
            Task {
                try? await Task.sleep(for: .seconds(2))
                
                // Animación cíclica infinita
                withAnimation(
                    .easeInOut(duration: 3.0)
                    .repeatForever(autoreverses: true)
                ) {
                    scale = 1.15
                }
            }
        }
    }
    
    /*struct MangaCoverView: View {
        let urlString: String
        @State private var vm = CoverVM()
        
        var body: some View {
            Group {
                
                if let image = vm.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
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
    }*/
}

#Preview {
    MangaDetailView(manga: Manga.testMangas[0])
}
