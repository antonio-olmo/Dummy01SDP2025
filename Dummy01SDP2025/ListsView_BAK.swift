//
//  ThemesView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 19/12/25.
//

import SwiftUI

struct ListsView_BAK: View {
    
    @State private var vm = ListsVM()
    
    var body: some View {
        
        Picker("Select an item", selection: $vm.selectedItem) {
            ForEach(vm.items, id: \.self) { item in
                Text(item).tag(item)
            }
        }
        .pickerStyle(.segmented)
        .frame(width: 300)
        .padding(.top, 10)
        /*.onChange(of: vm.selectedItem) { oldValue, newValue in
            
            //vm.dataLoaded = false
            // O si quieres recargar los datos automáticamente:
            switch newValue {
            case "Temas":
                if !vm.dataThemesLoaded {
                    vm.loadInitMangas()
                }
            case "Géneros":
                if !vm.dataGenresLoaded {
                    vm.loadInitMangas()
                }
            default:
                if !vm.dataDemographicsLoaded {
                    vm.loadInitMangas()
                }
            }
            
            /*if !vm.dataLoaded {
                vm.loadInitMangas()
            }*/
            
            //vm.loadInitMangas()
        }
        
        ListView(vm: vm)*/
         

        switch vm.selectedItem {
            case "Temas":
                ListThemesView(vm: vm)
            case "Géneros":
                //Text("Genres")
                ListGenresView(vm: vm)
            case "Demografía":
                //Text("Demografía")
                ListDemographicsView(vm: vm)
            default:
                Text("")
        }
        
        
    }
    
    /*struct ListView: View {
        
        var vm: ListsVM
        
        var body: some View {
            
            NavigationStack {
                
                ScrollView {
                    LazyVStack (alignment: .center) {
                        
                        ForEach(vm.lists.sorted(), id: \.self) { item in
                            NavigationLink(value: item) {
                                MangaListRow(list: item, listsDictionary: vm.listsDictionary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .safeAreaPadding()
                .navigationTitle("Mangas por \(vm.selectedItem) ...")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: String.self) { item in
                    
                    let mangasVM = MangasByListVM(
                        item: item,
                        itemDictionary: vm.listsDictionary,
                        randomPage: vm.randomPageListsDictionary[item] ?? 1,
                        list: 1
                    )
                    MangasByListView(vm: mangasVM)
                }
            }
            .onAppear {
                //if !vm.dataLoaded {
                    vm.loadInitMangas()
                //}
            }
            .refreshable {
                vm.loadInitMangas()
            }
        }
    }*/
    
    struct ListThemesView: View {
        
        var vm: ListsVM
        
        var body: some View {
            
            NavigationStack {
                
                ScrollView {
                    LazyVStack (alignment: .center) {
                        
                        ForEach(vm.lists.sorted(), id: \.self) { item in
                            NavigationLink(value: item) {
                                MangaListRow(list: item, listsDictionary: vm.listsDictionary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .safeAreaPadding()
                .navigationTitle("Mangas por \(vm.selectedItem) ...")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: String.self) { item in
                    
                    let mangasVM = MangasByListVM(
                        item: item,
                        itemDictionary: vm.listsDictionary,
                        randomPage: vm.randomPageListsDictionary[item] ?? 1,
                        list: 1
                    )
                    MangasByListView(vm: mangasVM)
                }
            }
            .onAppear {
                if !vm.dataThemesLoaded {
                    vm.loadInitMangas()
                }
            }
            .refreshable {
                vm.loadInitMangas()
            }
        }
    }
    
    struct ListGenresView: View {
        
        var vm: ListsVM
        
        var body: some View {
            
            NavigationStack {
                
                ScrollView {
                    LazyVStack (alignment: .center) {
                        
                        ForEach(vm.lists.sorted(), id: \.self) { item in
                            NavigationLink(value: item) {
                                MangaListRow(list: item, listsDictionary: vm.listsDictionary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .safeAreaPadding()
                .navigationTitle("Mangas por \(vm.selectedItem) ...")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: String.self) { item in
                    
                    let mangasVM = MangasByListVM(
                        item: item,
                        itemDictionary: vm.listsDictionary,
                        randomPage: vm.randomPageListsDictionary[item] ?? 1,
                        list: 1
                    )
                    MangasByListView(vm: mangasVM)
                }
            }
            .onAppear {
                if !vm.dataGenresLoaded {
                    vm.loadInitMangas()
                }
            }
            .refreshable {
                vm.loadInitMangas()
            }
        }
    }
    
    struct ListDemographicsView: View {
        
        var vm: ListsVM
        
        var body: some View {
            
            NavigationStack {
                
                ScrollView {
                    LazyVStack (alignment: .center) {
                        
                        ForEach(vm.lists.sorted(), id: \.self) { item in
                            NavigationLink(value: item) {
                                MangaListRow(list: item, listsDictionary: vm.listsDictionary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .safeAreaPadding()
                .navigationTitle("Mangas por \(vm.selectedItem) ...")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: String.self) { item in
                    
                    let mangasVM = MangasByListVM(
                        item: item,
                        itemDictionary: vm.listsDictionary,
                        randomPage: vm.randomPageListsDictionary[item] ?? 1,
                        list: 1
                    )
                    MangasByListView(vm: mangasVM)
                }
            }
            .onAppear {
                if !vm.dataDemographicsLoaded {
                    vm.loadInitMangas()
                }
            }
            .refreshable {
                vm.loadInitMangas()
            }
        }
    }
    
    /*struct ListThemesView: View {
        
        var vm: ThemesVM
        
        var body: some View {
            
            NavigationStack {
                
                ScrollView {
                    LazyVStack (alignment: .center) {
                        
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
                .navigationTitle("Mangas por Temas ...")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: String.self) { item in
                    
                    let mangasVM = MangasByListVM(
                        item: item,
                        itemDictionary: vm.themesDictionary,
                        randomPage: vm.randomPageThemesDictionary[item] ?? 1,
                        list: 1
                    )
                    MangasByListView(vm: mangasVM)
                }
            }
            .onAppear {
                if !vm.dataLoaded {
                    vm.loadInitMangas()
                }
            }
            .refreshable {
                vm.loadInitMangas()
            }
        }
    }
    
    struct ListGenresView: View {
        
        var vm: GenresVM
        
        var body: some View {
            
            NavigationStack {
                
                ScrollView {
                    LazyVStack (alignment: .center) {
                        
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
                .navigationTitle("Mangas por Géneros ...")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: String.self) { item in
                    
                    let mangasVM = MangasByListVM(
                        item: item,
                        itemDictionary: vm.genresDictionary,
                        randomPage: vm.randomPageGenresDictionary[item] ?? 1,
                        list: 2
                    )
                    MangasByListView(vm: mangasVM)
                }
            }
            .onAppear {
                if !vm.dataLoaded {
                    vm.loadInitMangas()
                }
            }
            .refreshable {
                vm.loadInitMangas()
            }
        }
    }
    
    struct ListDemographicsView: View {
        
        var vm: DemographicVM
        
        var body: some View {
            
            NavigationStack {
                
                ScrollView {
                    LazyVStack (alignment: .center) {
                        
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
                .navigationTitle("Mangas por Demografías ...")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: String.self) { item in
                    
                    let mangasVM = MangasByListVM(
                        item: item,
                        itemDictionary: vm.demographicsDictionary,
                        randomPage: vm.randomPageDemographicsDictionary[item] ?? 1,
                        list: 3
                    )
                    MangasByListView(vm: mangasVM)
                }
            }
            .onAppear {
                if !vm.dataLoaded {
                    vm.loadInitMangas()
                }
            }
            .refreshable {
                vm.loadInitMangas()
            }
        }
    }*/
}

#Preview {
    ListsView()
}
