//
//  Model.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 14/12/25.
//

import Foundation

struct User: Codable {
    var email: String
    var password: String
}

struct Token: Codable {
    var token: String
}

struct UserError: Codable {
    var error: Bool
    var reason: String
}

struct Manga: Codable, Identifiable, Hashable {
    
    let id: Int
    let url: URL?
    let score: Double
    let mainPicture: String?
    let sypnosis: String?
    let title: String
    let volumes: Int?
    let startDate: String? //Date?
    let status: Status
    let authors: [Author]
    let themes: [Theme]
    let demographics:[Demographic]
    let titleEnglish: String?
    let background: String?
    let chapters: Int?
    let titleJapanese: String?
    let genres: [String]//[Genre]    
    let endDate: String? //Date?
}

enum Status: String, Codable {
    case publishing = "currently_publishing"
    case discontinued
    case on_hiatus
    case finished
    case none
}

struct Author: Codable, Identifiable, Hashable {
    let id: UUID
    let role: Roles
    let lastName: String
    let firstName: String
}

enum Roles: String, Codable {
    case storyAndArt = "Story & Art"
    case art = "Art"
    case story = "Story"
    case none = "None"
}

struct Theme: Codable, Identifiable, Hashable {
    let id: UUID
    let theme: String
}

struct Demographic: Codable, Identifiable, Hashable {
    let id: UUID
    let demographic: String
}

struct Genre: Codable, Identifiable, Hashable {
    let id: UUID
    let genre: String
}

extension Manga {
    /*static let testMangaTheme: [String:[Manga]] = [
        "Romantic": [
            Manga(id: 1, url: URL(string: ""), score: 2, mainPicture: "", sypnosis: "", title: "", volumes: 0, startDate: "", status: .none, authors: [Author(id: UUID(), role: .none, lastName: "", firstName: "")], themes: [Theme(id: UUID(), theme: "")], demographics: [Demographic(id: UUID(), demographic: "")], titleEnglish: "", background: "", chapters: 0, titleJapanese: "", genres: [""], endDate: "")
        ]
    ]*/
    
    static let testMangas: [Manga] = [
        Manga(
            id: 142,
            url: URL(string: "https://myanimelist.net/manga/142/Battle_Royale"),
            score: 7.88,
            mainPicture: "https://cdn.myanimelist.net/images/manga/1/262978l.jpg",
            sypnosis: "Every year, a class is randomly chosen to be placed in a deserted area where they are forced to kill each other in order to survive. Initially believing to be on a graduation trip, Shuuya Nanahara and the rest of Shiroiwa Junior High's Class B find that they have been chosen to participate in this game of life and death known as The Program.\n\nWaking up to the realization that they have been quarantined on an island, the 42 students discover they have been fitted with metal collars which will detonate if certain conditions are not met. In order to obtain freedom, they must slaughter everyone else by whatever means necessary, and the last one standing is deemed the winner. As each member of the class heads down their own path, Shuuya makes it his goal to get off the island without playing the game in order to put an end to this madness once and for all.\n\n[Written by MAL Rewrite]",
            title: "Battle Royale",
            volumes: 15,
            startDate: "2000-01-01T00:00:00Z",
            status: .finished,
            authors: [
                Author(id: UUID(uuidString: "9E306C13-B24E-4974-84BD-A23C95E38F84")!, role: .art, lastName: "Taguchi", firstName: "Masayuki"),
                Author(id: UUID(uuidString: "AF45A9E8-CF80-4256-B072-0B985658C2C7")!, role: .story, lastName: "Takami", firstName: "Koushun")
            ],
            themes: [
                Theme(id: UUID(uuidString: "82728A80-0DBE-4B64-A295-A25555A4A4A5")!, theme: "Gore"),
                Theme(id: UUID(uuidString: "4394C99F-615B-494A-929E-356A342A95B8")!, theme: "Psychological"),
                Theme(id: UUID(uuidString: "E0FF84D2-35D4-40F0-8689-6B37D6C189DD")!, theme: "Survival")
            ],
            demographics: [
                Demographic(id: UUID(uuidString: "CE425E7E-C7CD-42DB-ADE3-1AB9AD16386D")!, demographic: "Seinen")
            ],
            titleEnglish: "Battle Royale",
            background: "Battle Royale is an adaptation of Koushun Takami's novel of the same name which was published in April 1999 (and later published in English by VIZ Media). The novel was adapted into a live-action film the following year and became one of Japan's highest grossing films, though it was condemned by the National Diet.",
            chapters: 119,
            titleJapanese: "バトル・ロワイアル",
            genres: ["Action", "Drama", "Horror", "Suspense"],
            endDate: "2005-01-01T00:00:00Z"
        ),
        Manga(
            id: 219,
            url: URL(string: "https://myanimelist.net/manga/219/Alive__Saishuu_Shinkateki_Shounen"),
            score: 7.79,
            mainPicture: "https://cdn.myanimelist.net/images/manga/1/185482l.jpg",
            sypnosis: "Taisuke Kanou is your average 16-year-old student. He has two close friends, Hirose and Megumi. Hirose has trouble with bullies, but Taisuke is always there to defend him, even though he just winds up getting beaten instead of Hirose. During class one day, Taisuke is hit by something unworldly and for that split second, he sees a vision of the universe. As he's walking home from school, he sees a girl fall and die in front of him, but his first thought is jealousy. He later finds out that the strange sensation that hit him is spreading throughout Japan. Those who are struck by it either commit suicide or \"evolve,\" but the comrades that evolve usually have dark intentions for the rest of the world.\n\n(Source: ANN)",
            title: "Alive: Saishuu Shinkateki Shounen",
            volumes: 21,
            startDate: "2003-04-05T00:00:00Z",
            status: .finished,
            authors: [
                Author(id: UUID(uuidString: "1C260BC4-981D-4D5E-89DF-71C6F68E1A00")!, role: .story, lastName: "Kawashima", firstName: "Tadashi"),
                Author(id: UUID(uuidString: "C61D0FA2-92E6-4117-8D38-E179A1E12442")!, role: .storyAndArt, lastName: "Adachitoka", firstName: "")
            ],
            themes: [
                Theme(id: UUID(uuidString: "E0FF84D2-35D4-40F0-8689-6B37D6C189DD")!, theme: "Survival")
            ],
            demographics: [
                Demographic(id: UUID(uuidString: "5E05BBF1-A72E-4231-9487-71CFE508F9F9")!, demographic: "Shounen")
            ],
            titleEnglish: "Alive: The Final Evolution",
            background: "An anime adaptation was planned for Alive: Saishuu Shinkateki Shounen and was to be produced by anime studio , but the production was cancelled in 2010 when the studio was delisted from the Tokyo Stock Exchange.",
            chapters: 83,
            titleJapanese: "アライブ 最終進化的少年",
            genres: ["Adventure", "Supernatural", "Sci-Fi"],
            endDate: "2010-02-06T00:00:00Z"
        ),
        Manga(
            id: 395,
            url: URL(string: "https://myanimelist.net/manga/395/Ibara_no_Ou"),
            score: 7.51,
            mainPicture: "https://cdn.myanimelist.net/images/manga/3/180829l.jpg",
            sypnosis: "Two twins, separated by fatal illness and a selective cure. Kasumi and her sister, Shizuku, were infected with the Medusa virus, which slowly turns the victim to stone. There is no cure, but of the two only Kasumi is selected to go into a sort of cryogenically frozen state along with 159 others until a cure is found. At some point in the undetermined future, Kasumi awakens to find herself and others who were in suspended animation in an unfamiliar world with violent monsters. Resolving to unlock the mysteries of her current situation and the fate of her twin sister, Kasumi struggles to survive in a treacherous world.\n\n(Source: Tokyopop)",
            title: "Ibara no Ou",
            volumes: 6,
            startDate: "2002-09-12T00:00:00Z",
            status: .finished,
            authors: [
                Author(id: UUID(uuidString: "21436E2B-67A3-4215-BE6A-109A614315C4")!, role: .storyAndArt, lastName: "Iwahara", firstName: "Yuji")
            ],
            themes: [
                Theme(id: UUID(uuidString: "E0FF84D2-35D4-40F0-8689-6B37D6C189DD")!, theme: "Survival")
            ],
            demographics: [
                Demographic(id: UUID(uuidString: "CE425E7E-C7CD-42DB-ADE3-1AB9AD16386D")!, demographic: "Seinen")
            ],
            titleEnglish: "King of Thorn",
            background: "Ibara no Ou was published in English as King of Thorn by Tokyopop from June 12, 2007 to November 4, 2008.",
            chapters: 37,
            titleJapanese: "いばらの王",
            genres: ["Action", "Drama", "Sci-Fi"],
            endDate: "2005-09-12T00:00:00Z"
        )
    ]
    
    static let testMangaTheme: [String:[Manga]] = [
        "Survival": [testMangas[0], testMangas[1], testMangas[2]]/*,
        "Gore": [testMangas[0]],
        "Psychological": [testMangas[0]]*/
    ]
}
