//
//  ThemesView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 19/12/25.
//

import SwiftUI

struct ListsView: View {
    
    @State private var vmThemes = ThemesVM()
    @State private var vmGenres = GenresVM()
    @State private var vmDemographics = DemographicVM()
    
    @State private var selectedItem = "Temas"
    let items = ["Temas", "Géneros", "Demografía"]
    
    var body: some View {
                    
        Picker("Select an item", selection: $selectedItem) {
            ForEach(items, id: \.self) { item in
                Text(item).tag(item)
            }
        }
        .pickerStyle(.segmented)
        .frame(width: 300)
        .padding(.top, 10)
        
        switch selectedItem {
        case "Temas":
            ListThemesView(vm: vmThemes)
        case "Géneros":
            //Text("Genres")
            ListGenresView(vm: vmGenres)
        case "Demografía":
            //Text("Demografía")
            ListDemographicsView(vm: vmDemographics)
        default:
            Text("")
        }
    }
    
    struct ListThemesView: View {
        
        var vm: ThemesVM
        
        var body: some View {
            
            NavigationStack {
                    
                ScrollView {
                    LazyVStack (alignment: .center) {
                        
                        //ListThemesView(vm: vm)
                        
                        ForEach(vm.themes.sorted(), id: \.self) { item in
                            NavigationLink(value: item) {
                                MangaListRow(list: item, listsDictionary: vm.themesDictionary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .safeAreaPadding()
                //.padding(.horizontal)
                .navigationTitle("Mangas por Temas ...")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: String.self) { item in
                    //BookView(book: book, namespace: namespace)
                    
                    
                    /*let mangasVM = MangasByThemeVM(
                     theme: theme,
                     themeDictionary: vm.themesDictionary,
                     randomPage: vm.randomPageThemesDictionary[theme] ?? 1
                     )
                     MangasByListView(vm: mangasVM)*/
                    
                    let mangasVM = MangasByListVM(
                        item: item,
                        itemDictionary: vm.themesDictionary,
                        randomPage: vm.randomPageThemesDictionary[item] ?? 1,
                        list: 1
                    )
                    MangasByListView(vm: mangasVM)
                }
                .refreshable {
                    vm.loadInitMangas()
                }
            }
            .onAppear {
                if !vm.dataLoaded {
                    vm.loadInitMangas()
                }
            }
        }
    }
    
    struct ListGenresView: View {
        
        var vm: GenresVM
        
        var body: some View {
            
            NavigationStack {
                
                ScrollView {
                    LazyVStack (alignment: .center) {
                        
                        //ListThemesView(vm: vm)
                        
                        ForEach(vm.genres.sorted(), id: \.self) { item in
                            NavigationLink(value: item) {
                                MangaListRow(list: item, listsDictionary: vm.genresDictionary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .safeAreaPadding()
                //.padding(.horizontal)
                .navigationTitle("Mangas por Géneros ...")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: String.self) { item in
                    //BookView(book: book, namespace: namespace)
                    
                    
                    /*let mangasVM = MangasByThemeVM(
                        theme: theme,
                        themeDictionary: vm.genresDictionary,
                        randomPage: vm.randomPageGenresDictionary[theme] ?? 1
                    )
                    MangasByListView(vm: mangasVM)*/
                    
                    let mangasVM = MangasByListVM(
                        item: item,
                        itemDictionary: vm.genresDictionary,
                        randomPage: vm.randomPageGenresDictionary[item] ?? 1,
                        list: 2
                    )
                    MangasByListView(vm: mangasVM)
                }
                .refreshable {
                    vm.loadInitMangas()
                }
            }
            .onAppear {
                if !vm.dataLoaded {
                    vm.loadInitMangas()
                }
            }
        }
    }
    
    struct ListDemographicsView: View {
        
        var vm: DemographicVM
        
        var body: some View {
            
            NavigationStack {
                
                ScrollView {
                    LazyVStack (alignment: .center) {
                        
                        //ListThemesView(vm: vm)
                        
                        ForEach(vm.demographics.sorted(), id: \.self) { item in
                            NavigationLink(value: item) {
                                MangaListRow(list: item, listsDictionary: vm.demographicsDictionary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .safeAreaPadding()
                //.padding(.horizontal)
                .navigationTitle("Mangas por Demografías ...")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: String.self) { item in
                    //BookView(book: book, namespace: namespace)
                    
                    
                    /*let mangasVM = MangasByThemeVM(
                        theme: theme,
                        themeDictionary: vm.demographicsDictionary,
                        randomPage: vm.randomPageDemographicsDictionary[theme] ?? 1
                    )
                    MangasByListView(vm: mangasVM)*/
                    
                    let mangasVM = MangasByListVM(
                        item: item,
                        itemDictionary: vm.demographicsDictionary,
                        randomPage: vm.randomPageDemographicsDictionary[item] ?? 1,
                        list: 3
                    )
                    MangasByListView(vm: mangasVM)
                }
                .refreshable {
                    vm.loadInitMangas()
                }
                
            }
            .onAppear {
                if !vm.dataLoaded {
                    vm.loadInitMangas()
                }
            }
        }
    }
    
    /*struct MangaCard: View {
        let manga: Manga
        @State private var isPressed = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                // Cover Image
                AsyncImage(url: manga.mainPicture) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(LinearGradient(
                                colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .overlay {
                                ProgressView()
                                    .tint(.white)
                            }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .overlay {
                                Image(systemName: "book.closed.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 140, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                
                // Info Section
                VStack(alignment: .leading, spacing: 6) {
                    Text(manga.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    /*Text(manga.author)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)*/
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(.yellow)
                        
                        Text(String(format: "%.1f", manga.score))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 12)
                .padding(.horizontal, 4)
            }
            .frame(width: 140)
            .padding(.bottom, 8)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.background)
                    .shadow(color: .black.opacity(0.08), radius: isPressed ? 4 : 12, x: 0, y: isPressed ? 2 : 6)
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
            .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                isPressed = pressing
            }, perform: {})
        }
    }*/
}

#Preview {
    ListsView()
}
