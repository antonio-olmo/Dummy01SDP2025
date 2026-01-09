//
//  EmpleadosVM.swift
//  EmpleadosAPI
//
//  Created by Julio César Fernández Muñoz on 20/11/25.
//

import SwiftUI

enum ViewState {
    case loading
    case loaded
    case empty
}

@Observable @MainActor
final class MangasVM {
    let repository: NetworkRepository
    
    let stepPer = 20
        
    @ObservationIgnored
    @AppStorage("totalMangas") private var totalMangas = 0
    
    /*@ObservationIgnored
    @AppStorage("mangasPagesVisited") private var mangasPagesVisitedData: Data = Data()
    var mangasPagesVisited: [Int] {
        get {
            (try? JSONDecoder().decode([Int].self, from: mangasPagesVisitedData)) ?? []
        }
        set {
            mangasPagesVisitedData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }*/
    
    var mangas: [Manga] = []
        
    var state: ViewState = .loading
    
    var showError = false
    var errorMsg = ""
    
    init(repository: NetworkRepository = Network()) {
        self.repository = repository
        self.loadInitMangas()
    }
    
    func loadInitMangas() {
        if self.totalMangas == 0 {
            Task {
                await self.getTotalMangas()
                await self.getMangas()
                //self.mangasPagesVisited.append(self.totalMangas == 0 ? 1 : self.totalMangas / self.stepPer)
            }
            
        } else {
            //self.mangasPagesVisited.append(self.totalMangas / self.stepPer)
            Task {                
                await self.getMangas()
                //self.mangasPagesVisited.append(self.totalMangas == 0 ? 1 : self.totalMangas / self.stepPer)
            }
        }
    }
    
    func getTotalMangas() async {
        do {
            
            //self.totalMangas = try await repository.getTotalMangas()
            self.totalMangas = try await repository.getTotalList(url: .getMangas(page: 1, per: 1))
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print(error)
        }
    }
    
    func getMangas() async {
        do {
            let randomPage = Int.random(in: 1...Int((Double(self.totalMangas) / Double(self.stepPer)).rounded(.up)))
            self.mangas = try await repository.getMangas(page: randomPage, per: self.stepPer)
            
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print(error)
        }
        if mangas.isEmpty {
            state = .empty
        }
    }
    
    func getBestMangas() async {
        do {
            self.mangas = try await repository.getBestMangas()
        } catch {
            errorMsg = error.localizedDescription
            showError.toggle()
            print(error)
        }
        if mangas.isEmpty {
            state = .empty
        }
    }
    
    /*func getStringMainPicture (mainPicture: String?) -> String {
        if let mainPicture {
            return mainPicture.replacingOccurrences(of: "h", with: "")
        } else {
            return ""
        }
    }*/
    
}
