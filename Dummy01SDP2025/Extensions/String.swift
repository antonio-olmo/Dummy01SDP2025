//
//  String.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 21/12/25.
//

import Foundation


extension String {
    static func getStringMainPicture (mainPicture: String?) -> String {
        if let mainPicture {
            return mainPicture.replacingOccurrences(of: "\"", with: "")
        } else {
            return ""
        }
    }
    
    func formatMangaDate() -> String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: self) else { return "Desconocida" }
        
        let formatted = date.formatted( // No queremos horas ...
            .dateTime
                .day(.twoDigits)
                .month(.twoDigits)
                .year()
        )
        
        // Quitamos las barras, jejeje
        return formatted
            .replacing("/", with: "-")
    }
}
