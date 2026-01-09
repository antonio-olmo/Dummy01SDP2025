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
}
