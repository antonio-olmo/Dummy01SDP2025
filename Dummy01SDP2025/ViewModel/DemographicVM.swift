//
//  GenresView.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 19/12/25.
//

import SwiftUI

@Observable
@MainActor
final class DemographicVM {
    
    let repository: NetworkRepository
    
    let stepPer = 20
    var randomPage = 1
        
    //@ObservationIgnored
    //@AppStorage("totalGenres") private var totalGenres = 0
    
    var totalMangasByDemographic = 0
    
    var demographics: [String] = []
    var demographicsDictionary : [String:[Manga]] = [:]
    var randomPageDemographicsDictionary : [String:Int] = [:]
    
    var dataLoaded = false
    
    var showError = false
    var errorMsg = ""
    
    init(repository: NetworkRepository = Network()) {
        self.repository = repository
        //self.loadInitMangas()
    }
    
    func loadInitMangas() {
        Task {
            do {
                print ("inicio carga de demografías ...")
                self.demographics = try await repository.getDemographics()
                dataLoaded = true
                try await getMangasByDemographic()
                //dataLoaded = true
                print ("Fin de la carga: \(demographics.count) demografías")
            } catch {
                errorMsg = error.localizedDescription
                showError.toggle()
                print(error)
            }
        }
    }
    
    func getMangasByDemographic() async throws {
        guard demographics.count > 0 else { return }
        
        for demographic in self.demographics {
        
            await getTotalMangasByDemographic(demographic: demographic)
            self.randomPage = Int.random(in: 1...Int((Double(self.totalMangasByDemographic) / Double(self.stepPer)).rounded(.up)))
            let mangas = try await repository.getMangasByDemographic(demographic: demographic, page: self.randomPage, per: 3)
            self.demographicsDictionary[demographic] = mangas
            self.randomPageDemographicsDictionary[demographic] = self.randomPage
        }
    }
    
    func getTotalMangasByDemographic(demographic: String) async {
        do {
            self.totalMangasByDemographic = try await repository.getTotalList(url: .getMangasByDemographic(demographic: demographic, page: 1, per: 1))
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print(error)
        }
    }
}

