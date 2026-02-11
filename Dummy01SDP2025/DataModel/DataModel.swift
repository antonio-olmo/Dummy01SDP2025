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
    var titleEnglish: String?
    var mainPicture: String?
    var sypnosis: String?
    //@Relationship var authors: [AuthorData]
    
    /*init(id: Int, title: String, background: String, authors: [AuthorData]) {
        self.id = id
        self.title = title
        self.background = background
        self.authors = authors
    }*/
    
    init(id: Int, title: String, titleEnglish: String? = nil, mainPicture: String? = nil, sypnosis: String? = nil) {
        self.id = id
        self.title = title
        self.titleEnglish = titleEnglish
        self.mainPicture = mainPicture
        self.sypnosis = sypnosis
    }
    
}

extension MangaData {
    @MainActor static let testMangas: [MangaData] = [
        MangaData(
            id: 142,
            title: "Battle Royale",
            titleEnglish: "Battle Royale",
            mainPicture: "https://cdn.myanimelist.net/images/manga/1/262978l.jpg",
            sypnosis: "Every year, a class is randomly chosen to be placed in a deserted area where they are forced to kill each other in order to survive. Initially believing to be on a graduation trip, Shuuya Nanahara and the rest of Shiroiwa Junior High's Class B find that they have been chosen to participate in this game of life and death known as The Program.\n\nWaking up to the realization that they have been quarantined on an island, the 42 students discover they have been fitted with metal collars which will detonate if certain conditions are not met. In order to obtain freedom, they must slaughter everyone else by whatever means necessary, and the last one standing is deemed the winner. As each member of the class heads down their own path, Shuuya makes it his goal to get off the island without playing the game in order to put an end to this madness once and for all.\n\n[Written by MAL Rewrite]",

        )
    ]
}

/*@Model
final class AuthorData {
    
    @Attribute(.unique) var id: UUID
    var name: String
    
    @Relationship(deleteRule: .cascade, inverse: \MangaData.authors) var mangas: [MangaData]
    
    init(id: UUID, name: String, mangas: [MangaData]) {
        self.id = id
        self.name = name
        self.mangas = mangas
    }
}*/
