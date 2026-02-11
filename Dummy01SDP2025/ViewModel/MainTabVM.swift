//
//  EmpleadosVM.swift
//  EmpleadosAPI
//
//  Created by Julio César Fernández Muñoz on 20/11/25.
//

import SwiftUI

@Observable @MainActor
final class MainTabVM {
    
    var selectedTab = 0
    var mangasPath = NavigationPath()
    var listsPath = NavigationPath()
    var collectionPath = NavigationPath()
    var accountPath = NavigationPath()
    var searchPath = NavigationPath()
    
}
