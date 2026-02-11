//
//  MangaDetailView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 28/12/25.
//

import SwiftUI
import SwiftData

struct MangaDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State var vm = MangaDetailVM()
    @State var vmCover = CoverVM()
    @State private var showAddManga = false
    
    @State private var reload = false
    
    @State private var showSynopsis = false
    @State private var showBackground = false
    
    @State private var japaneseTitle = ""
    @State private var mangaLink: AttributedString = ""
    
    @State private var isFavourite = false
    
    let manga: Manga
    
    var body: some View {
    
        //GeometryReader { geometry in
            ScrollView {
                
                if let image = vmCover.image {
                    
                    VStack(spacing: 0) {
                        
                        GeometryReader { geometry in
                            
                            ZStack(alignment: .top) {
                                // Fondo con imagen estática en B&N con zoom
                                //if let image = vmCover.image {
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
                                
                                // Contenido principal
                                VStack(spacing: 20) {
                                    Spacer()
                                        .frame(height: 3)
                                    
                                    // Imagen animada principal
                                    //AnimatedZoomImageView(urlString: manga.mainPicture ?? "")
                                    AnimatedZoomImageView(image: vmCover.image)
                                        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                                    
                                    
                                    
                                    // Título y contenido adicional con más espacio
                                    /*VStack(spacing: 12) {
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
                                     }*/
                                }
                                //}
                            }
                            
                            
                        }
                        .frame(height: 480)
                        
                        mangaInfo
                    }
                    
                } else {
                        
                    /*ZStack (alignment: .center) {
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
                            .foregroundStyle(.secondary.opacity(0.8))
                    }
                    .frame(width: 100, height: 150)
                    /*.overlay(
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
                    )*/
                    .shadow(color: Color(red: 0.3, green: 0.2, blue: 0.5).opacity(0.7), radius: 10, x: 0, y: 10)
                    //.shadow(color: .black.opacity(0.5), radius: 0, x: 0, y: 15)*/
                    
                    VStack {
                        placeholder
                        mangaInfo
                    }
                }
                
                
            }
            .scrollIndicators(.hidden)
            .navigationTitle(manga.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    
                    if !vm.inCollection {
                        
                        if isFavourite {
                            Button {
                                do {
                                    if (try deleteFavouriteManga(manga.id)) {
                                        isFavourite = false
                                    }
                                } catch {
                                    print("ERROR en el borrado de favoritos")
                                }
                                
                            } label: {
                                Image(systemName: "star.slash.fill")
                            }
                        } else {
                            
                            Button {
                                print("imagen: \(manga.mainPicture ?? "nada")")
                                let manga = MangaData(id: manga.id, title: manga.title, mainPicture: .getStringMainPicture(mainPicture: manga.mainPicture), sypnosis: manga.sypnosis)
                                
                                modelContext.insert(manga)
                                isFavourite = true
                                
                            } label: {
                                Image(systemName: "star.fill")
                            }
                        }
                    }
                    
                    Button {
                        showAddManga.toggle()
                    } label: {
                        !vm.inCollection ? Image(systemName: "plus") : Image(systemName: "pencil")
                    }
                    
                    if vm.inCollection {
                        Button {
                            vm.alertMessage = "ATENCIÓN: Vas a borrar este manga de tu colección."
                            vm.showAlert.toggle()
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddManga) {
                if let mangaCollection = vm.mangaCollection {
                    
                    let detailVM = AddMangaVM(mangaCollection: mangaCollection)
                    AddMangaView(vm: detailVM, reload: $reload)
                } else {
                    let userCollection = UserCollection(
                        id: "",
                        manga: manga,
                        volumesOwned: [],
                        completeCollection: false,
                        readingVolume: 0
                    )
                    let detailVM = AddMangaVM(mangaCollection: userCollection)
                    AddMangaView(vm: detailVM, reload: $reload)
                }
            }
            .alert("Borrado de Manga", isPresented: $vm.showAlert) {
                Button("Cancelar", role: .cancel) {}
                
                Button("Borrar", role: .destructive) {
                    Task {
                        await vm.deleteMangaCollection(id: manga.id)
                        //if vm.mangaDeletedFromCollection {
                            //reload.toggle()
                            dismiss()
                        //}
                    }
                }
            } message: {
                Text(vm.alertMessage)
            }
            .onAppear {
                
                do {
                    self.isFavourite = try self.getFavouriteManga(manga.id)
                } catch {
                    self.isFavourite = false
                }
                
                japaneseTitle = vm.japaneseTitle(
                    manga.titleJapanese,
                    manga.titleEnglish,
                    manga.title)
                if let mangaURL = manga.url {
                    mangaLink = vm.linkText(url: mangaURL)
                }
                
                vmCover.getImage(cover: URL(string: .getStringMainPicture(mainPicture: manga.mainPicture ?? "")))
                print("Manga Id: \(manga.id)")
                vm.loadInitManga(manga.id)
            }
            .onChange(of: reload) { oldValue, newValue in
                if newValue {
                    print("RELOAD ...")
                    vm.loadInitManga(manga.id)
                    reload.toggle()
                }
            }
        //}
    }
    
    func getFavouriteManga(_ id: Int) throws -> Bool {
        let fetch = FetchDescriptor<MangaData>(predicate: #Predicate{$0.id == id})
        let query = try modelContext.fetchCount(fetch)
        if query == 1 {
            return true
        } else {
            return false
        }
    }
    
    func deleteFavouriteManga(_ id: Int) throws -> Bool {
        let fetch = FetchDescriptor<MangaData>(predicate: #Predicate{$0.id == id})
        let results = try modelContext.fetch(fetch)
        
        guard let mangaToDelete = results.first else {
            return false
        }
        
        modelContext.delete(mangaToDelete)
        return true
    }
    
    struct AnimatedZoomImageView: View {
        //let urlString: String
        let image: UIImage?
        
        @State private var vm = CoverVM()
        @State private var scale: CGFloat = 1.0
        
        var body: some View {
            Group {
                                    
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
                } /*else {
                    placeholder
                }*/
                
            }
            .frame(width: 300, height: 450)
            .onAppear {
                //vm.getImage(cover: URL(string: .getStringMainPicture(mainPicture: urlString)))
                startBreathingAnimation()
            }
        }
        
        /*private var placeholder: some View {
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
        }*/
        
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
    
    private var placeholder: some View {
        
        ZStack (alignment: .center) {
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
                .foregroundStyle(.secondary.opacity(0.8))
        }
        .frame(width: 100, height: 150)
        .shadow(color: Color(red: 0.3, green: 0.2, blue: 0.5).opacity(0.7), radius: 10, x: 0, y: 10)
    }
    
    private var mangaInfo: some View {
        
        VStack {
            
            VStack(spacing: 0) {
                Text(manga.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 20) // Más separación desde la imagen
                
                if japaneseTitle != "" {
                    Text(japaneseTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .padding(.horizontal,20)
                }
                
                if manga.themes.count > 0 {
                    Text(manga.themes.map { $0.theme }.joined(separator: ", "))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                }
                
                //TODO: Genres es un array de STRINGSS
                if manga.genres.count > 0 {
                 Text(manga.genres.map { $0.genre }.joined(separator: ", "))
                 .font(.footnote)
                 .foregroundStyle(.secondary)
                }
                
                if manga.demographics.count > 0 {
                    Text(manga.demographics.map { $0.demographic }.joined(separator: ", "))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            
            VStack(spacing: 12) {
                
                RatingView(rating: (manga.score * 5) / 10, originalRating: manga.score < 0 ? 0 : manga.score)
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                
                // ****** tabla de vol / chap
                
                // Tabla de Capítulos y Volúmenes
                Grid(horizontalSpacing: 16, verticalSpacing: 0) {
                    GridRow {
                        // Columna 1: Capítulos
                        VStack(spacing: 8) {
                            Text("Capítulos")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            Text(manga.chapters != nil ? "\(manga.chapters!)" : "???")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.purple.opacity(0.08), Color.blue.opacity(0.08)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            Color.purple.opacity(0.3),
                                            Color.blue.opacity(0.3)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                        
                        // Columna 2: Volúmenes
                        VStack(spacing: 8) {
                            Text("Volúmenes")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            Text(manga.volumes != nil ? "\(manga.volumes!)" : "???")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.purple.opacity(0.08), Color.blue.opacity(0.08)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            Color.purple.opacity(0.3),
                                            Color.blue.opacity(0.3)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // ******
                
                // Tabla de Publicaciones
                Grid(horizontalSpacing: 16, verticalSpacing: 0) {
                    GridRow {
                        // Columna 1: Publicación ...
                        VStack(spacing: 8) {
                            Text("Publicado en")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            HStack {
                                Image(systemName: "calendar.circle.fill")
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.purple.opacity(0.7), .blue.opacity(0.7)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .font(.system(size: 30, weight: .medium))
                                Text(manga.startDate?.formatMangaDate() ?? "???")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.purple.opacity(0.08), Color.blue.opacity(0.08)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            Color.purple.opacity(0.3),
                                            Color.blue.opacity(0.3)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                        
                        // Columna 2: Finalizaciónnnn ...
                        VStack(spacing: 8) {
                            Text("Finalizado en")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            HStack {
                                Image(systemName: "calendar.circle.fill")
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.red.opacity(0.3), .red.opacity(0.8)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .font(.system(size: 30, weight: .medium))
                                VStack {
                                    Text(manga.endDate?.formatMangaDate() ?? "???")
                                    Text(manga.status.rawValue)
                                        .foregroundStyle(.gray)
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                        .fontDesign(.rounded)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.purple.opacity(0.08), Color.blue.opacity(0.08)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            Color.purple.opacity(0.3),
                                            Color.blue.opacity(0.3)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // ******
                
                Text("Autores y Roles")
                    .font(.title3)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    
                
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(manga.authors) { author in
                                VStack(spacing: 2) {
                                    Image(systemName: "person.circle.fill")
                                        .font(.system(size: 30))
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [.purple.opacity(0.7), .blue.opacity(0.7)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                    
                                    Text("\(author.firstName)")
                                        .font(.footnote)
                                        .fontWeight(.medium)
                                        .multilineTextAlignment(.center)
                                    //.lineLimit(3)
                                        .frame(maxWidth: 100)
                                    
                                    Text("\(author.lastName)")
                                        .font(.footnote)
                                        .fontWeight(.medium)
                                        .multilineTextAlignment(.center)
                                    //.lineLimit(3)
                                        .frame(maxWidth: 100)
                                    
                                    Text(author.role.rawValue)
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(width: 96) // 100 + 8*2 padding
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .strokeBorder(
                                            LinearGradient(
                                                colors: [
                                                    Color.purple.opacity(0.3),
                                                    Color.blue.opacity(0.3)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                            }
                        }
                        .padding(.horizontal, max(0, (geometry.size.width - CGFloat(manga.authors.count) * 116) / 2))
                    }
                    .padding(.horizontal, 10)
                }
                .frame(height: 120)
                
                // *************
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Esto para la Sinopsis ... no sé, no sé (tbm en resumen !!!)
                    if let sinopsis = manga.sypnosis, sinopsis != "" {
                        VStack(alignment: .leading, spacing: 8) {
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                                    showSynopsis.toggle()
                                    if showSynopsis {
                                        showBackground = false
                                    }
                                }
                            } label: {
                                HStack {
                                    Label("Sinopsis", systemImage: "text.quote")
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .rotationEffect(.degrees(showSynopsis ? 180 : 0))
                                        .foregroundStyle(.purple)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                )
                            }
                            .buttonStyle(.plain)
                            
                            if showSynopsis {
                                Text(sinopsis)
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(Color(uiColor: .secondarySystemBackground))
                                    )
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .top).combined(with: .opacity),
                                        removal: .move(edge: .top).combined(with: .opacity)
                                    ))
                            }
                        }
                    }
                    
                    // Info
                    if let backGround = manga.background, backGround != "" {
                        VStack(alignment: .leading, spacing: 8) {
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                                    showBackground.toggle()
                                    if showBackground {
                                        showSynopsis = false
                                    }
                                }
                            } label: {
                                HStack {
                                    Label("Información", systemImage: "info.circle")
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .rotationEffect(.degrees(showBackground ? 180 : 0))
                                        .foregroundStyle(.purple)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                )
                            }
                            .buttonStyle(.plain)
                            
                            if showBackground {
                                Text(backGround)
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(Color(uiColor: .secondarySystemBackground))
                                    )
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .top).combined(with: .opacity),
                                        removal: .move(edge: .top).combined(with: .opacity)
                                    ))
                            }
                        }
                        
                    }
                }
                .padding(.horizontal)
                .padding(.top, 5)
                .padding(.bottom, 20)
                
                if mangaLink != "" {
                    
                    HStack {
                        Image(systemName: "link.circle.fill")
                            .font(.title)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.purple.opacity(0.7), .blue.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        Text(mangaLink)
                    }
                    .padding(.bottom,30)
                }
                
                // *************
            }
        }
    }
}

#Preview {
    MangaDetailView(manga: Manga.testMangas[0])
}
