//
//  SearchViewModel.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 16/12/25.
//

import SwiftUI

@Observable
@MainActor
final class SearchVM {
    
    let repository: NetworkRepository
    
    var search = ""
    var mangaResult: [Manga] = []
    
    //var searchType: URL = .findBooks1(search: <#T##String#>)
    
    init(repository: NetworkRepository = Network()) {
        self.repository = repository
    }
    
    func findBooks() async {
        do {
            mangaResult = try await repository.findBooks(url: .findBooks2(search: search))
        } catch {
            print(error)
        }
    }
    
    func initSearch() {
        search = ""
        mangaResult = []
    }
    
}
