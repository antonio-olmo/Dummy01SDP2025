//
//  DataModel.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 15/12/25.
//

import Foundation
import SwiftData

@Model
final class MangaData {
    
    @Attribute(.unique) var id: Int
    var title: String
    var background: String?
    @Relationship var authors: [AuthorData]
    
    init(id: Int, title: String, background: String, authors: [AuthorData]) {
        self.id = id
        self.title = title
        self.background = background
        self.authors = authors
    }
    
}

@Model
final class AuthorData {
    
    @Attribute(.unique) var id: UUID
    var name: String
    
    @Relationship(deleteRule: .cascade, inverse: \MangaData.authors) var mangas: [MangaData]
    
    init(id: UUID, name: String, mangas: [MangaData]) {
        self.id = id
        self.name = name
        self.mangas = mangas
    }
}
