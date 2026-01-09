//
//  URLRequest.swift
//  EmpleadosAPI
//
//  Created by Julio César Fernández Muñoz on 19/11/25.
//

import Foundation

extension URLRequest {
    static func get(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.timeoutInterval = 60
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        //request.setValue("Bearer lajsdñkajsdñlkjasdñlkjasñdlkj", forHTTPHeaderField: "Authorization")
        return request
    }
    
    static func post<JSON>(url: URL, body: JSON, headers: [[String : String]] = [], method: String = "POST") -> URLRequest where JSON: Codable {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = 60
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        headers.forEach { header in
            if let myHeader = header.first {
                request.setValue(myHeader.value, forHTTPHeaderField: myHeader.key)
            }
        }
        
        request.httpBody = try? JSONEncoder().encode(body)
        return request
    }
    
    static func post(url: URL, headers: [[String : String]] = [], method: String = "POST") -> URLRequest  {
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        request.timeoutInterval = 60
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        headers.forEach { header in
            if let myHeader = header.first {
                request.setValue(myHeader.value, forHTTPHeaderField: myHeader.key)
            }
        }
        
        return request
    }
}
