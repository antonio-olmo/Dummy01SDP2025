//
//  AddMangaVM.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 15/1/26.
//

import Foundation
import SwiftUI

@Observable @MainActor
final class AddMangaVM {
        
    let repository: NetworkRepository
    let keychainManager: KeychainManager
    
    var goLogin = false
    var collectionSaved = true
    
    var mangaCollection: UserCollection
    
    var readingVolume: Double = 0.0
    var readingVolumeText = ""
    var addedVolumesText = ""
    var completeCollection: Bool = false
    
    //var mangaTitle: String = ""
    //var author: String = ""
    var maxVolumes: Int = 10
    var currentVolume: Double = 0.0
    var isSliderEnabled: Bool = true
    var addedVolumes: [Int] = []
    
    var showAlert: Bool = false
    var alertMessage: String = ""
    
    /*var isFormValid: Bool {
        !mangaTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }*/
    
    init(repository: NetworkRepository = Network(), keychainManager: KeychainManager = KeychainManager.shared, mangaCollection: UserCollection) {
        self.repository = repository
        self.keychainManager = keychainManager
        self.mangaCollection = mangaCollection
        
        if let maxVolumes = self.mangaCollection.manga.volumes {
            if maxVolumes > 0 {
                //self.readingVolume = 1.0
                self.maxVolumes = maxVolumes
                self.isSliderEnabled = true
                self.currentVolume = 0.0
                
                self.readingVolume = Double(self.mangaCollection.readingVolume)
                self.addedVolumes = self.mangaCollection.volumesOwned
                self.completeCollection = self.mangaCollection.completeCollection
                
            } else {
                
                if self.mangaCollection.readingVolume > 0 {
                    self.readingVolumeText = String(self.mangaCollection.readingVolume)
                }
                self.addedVolumesText = self.mangaCollection.volumesOwned.map { String($0) }.joined(separator: ",")
                self.isSliderEnabled = false
            }
        } else {
            
            if self.mangaCollection.readingVolume > 0 {
                self.readingVolumeText = String(self.mangaCollection.readingVolume)
            }
            self.addedVolumesText = self.mangaCollection.volumesOwned.map { String($0) }.joined(separator: ",")
            self.isSliderEnabled = false
        }
        
        print("maxVolumes: \(maxVolumes)")
    }
    
    func addVolume() {
        
        print("antes ...")
        let volume = Int(currentVolume)
        guard !addedVolumes.contains(volume), volume > 0 else { return }
        print("después ...")
        
        addedVolumes.append(volume)
        addedVolumes.sort()
    }
    
    func removeVolume(_ volume: Int) {
        addedVolumes.removeAll { $0 == volume }
    }
    
    func saveManga() async  {
        
        if !isSliderEnabled {
            
            readingVolumeText = readingVolumeText == "" ? "0" : readingVolumeText
            readingVolume = Double(readingVolumeText) ?? 0.0
            
            addedVolumes = Array(Set(
                addedVolumesText.split(whereSeparator: { !$0.isNumber })
                    .compactMap { Int($0) }
                    .filter { $0 > 0 }
            )).sorted()
            
            addedVolumesText = addedVolumes.map { String($0) }.joined(separator: ",")
        }
        
        let newCollection = NewUserCollection(
            manga: mangaCollection.manga.id,
            volumesOwned: addedVolumes,
            completeCollection: completeCollection,
            readingVolume: Int(readingVolume)
        )
        
        //Task {
            
            do {
                try await self.setCollection(newCollection: newCollection)
            } catch KeychainManager.KeychainError.itemNotFound {
                print("No hay token. Vamos al login ...")
                try? keychainManager.deleteAuthToken()
                goLogin = true
                collectionSaved.toggle()
            } catch {
                print("Error al verificar token: \(error.localizedDescription)")
                // Si hay error, cerramos la sesión y para el login
                try? keychainManager.deleteAuthToken()
                goLogin = true
                collectionSaved.toggle()
            }
        //}
    }
    
    func setCollection(newCollection: NewUserCollection) async throws {
        
        let token = try keychainManager.getAuthToken()
        
        let auth = "Bearer \(token)"
        var headers = [[String: String]]()
        headers.append(["Authorization": auth])
        
        do {
            try await repository.setCollection(newUserCollection: newCollection, headers: headers)
            
        } catch {
            alertMessage = "No se pudo añadir a tu colección"
            showAlert.toggle()
        }
    }
}
