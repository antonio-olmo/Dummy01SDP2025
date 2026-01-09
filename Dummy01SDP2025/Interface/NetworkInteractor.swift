//
//  NetworkInteractor.swift
//  EmpleadosAPI
//
//  Created by Julio César Fernández Muñoz on 19/11/25.
//

import Foundation

protocol NetworkInteractor {}

extension NetworkInteractor {
    func getJSON<JSON>(_ request: URLRequest, type: JSON.Type) async throws(NetworkError) -> JSON where JSON: Codable {
        let (data, httpResponse) = try await URLSession.shared.getData(for: request)
        if httpResponse.statusCode == 200 {
            do {
                return try JSONDecoder().decode(type, from: data)
            } catch {
                throw NetworkError.json(error)
            }
        } else {
            throw NetworkError.status(httpResponse.statusCode)
        }
    }
    
    /*func postJSON(_ request: URLRequest, status: Int = 200) async throws(NetworkError) {
        let (_, httpResponse) = try await URLSession.shared.getData(for: request)
        if httpResponse.statusCode != status {
            throw NetworkError.status(httpResponse.statusCode)
        }
    }*/
    
    func postJSON(_ request: URLRequest, status: Int = 200) async throws(NetworkError) {
        let (data, httpResponse) = try await URLSession.shared.getData(for: request)
        if httpResponse.statusCode != status {
            
            if let userError = try? JSONDecoder().decode(UserError.self, from: data) {
                throw NetworkError.user(userError.reason)
            } else {
                throw NetworkError.status(httpResponse.statusCode)
            }
        }
    }
    
    func postJSON<JSON>(_ request: URLRequest, type: JSON.Type, status: Int = 200) async throws(NetworkError) -> JSON where JSON: Codable {
        let (data, httpResponse) = try await URLSession.shared.getData(for: request)
        if httpResponse.statusCode != status {
            
            if let userError = try? JSONDecoder().decode(UserError.self, from: data) {
                throw NetworkError.user(userError.reason)
            } else {
                throw NetworkError.status(httpResponse.statusCode)
            }
        } else {
            do {
                /*if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                } else {
                    print("No se pudo convertir data a String")
                }*/
                return try JSONDecoder().decode(type, from: data)
            } catch {
                throw NetworkError.json(error)
            }
        }
    }
}
