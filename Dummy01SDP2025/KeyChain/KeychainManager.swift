//
//  KeychainManager.swift
//  Dummy01SDP2025
//
//  Created by Antonio Olmo Ortiz on 1/3/26.
//

import Foundation
import Security

/// Protocolo para gestionar operaciones con el Keychain
protocol KeychainManaging: Sendable {
    func save(token: String, forKey key: String) throws
    func retrieve(forKey key: String) throws -> String
    func delete(forKey key: String) throws
}

/// Manager para gestionar tokens y credenciales en el Keychain del dispositivo
final class KeychainManager: KeychainManaging, @unchecked Sendable {
    
    enum KeychainError: LocalizedError {
        case duplicateItem
        case unknown(OSStatus)
        case itemNotFound
        case invalidData
        
        var errorDescription: String? {
            switch self {
            case .duplicateItem:
                return "El elemento ya existe en el Keychain"
            case .unknown(let status):
                return "Error desconocido del Keychain: \(status)"
            case .itemNotFound:
                return "No se encontró el elemento en el Keychain"
            case .invalidData:
                return "Los datos recuperados del Keychain son inválidos"
            }
        }
    }
    
    // Singleton para acceso global
    static let shared = KeychainManager()
    
    // Keys comunes para tu app
    struct Keys: Sendable {
        static let authToken = "com.dummy01sdp2025.authToken"
        static let userEmail = "com.dummy01sdp2025.userEmail"
    }
    
    private init() {}
    
    /// Guarda un token en el Keychain
    /// - Parameters:
    ///   - token: El token a guardar
    ///   - key: La clave única para identificar el token
    func save(token: String, forKey key: String) throws {
        guard let data = token.data(using: .utf8) else {
            throw KeychainError.invalidData
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        // Intentar agregar el item
        let status = SecItemAdd(query as CFDictionary, nil)
        
        switch status {
        case errSecSuccess:
            return
        case errSecDuplicateItem:
            // Si ya existe, lo actualizamos
            try update(token: token, forKey: key)
        default:
            throw KeychainError.unknown(status)
        }
    }
    
    /// Actualiza un token existente en el Keychain
    private func update(token: String, forKey key: String) throws {
        guard let data = token.data(using: .utf8) else {
            throw KeychainError.invalidData
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    /// Recupera un token del Keychain
    /// - Parameter key: La clave del token a recuperar
    /// - Returns: El token como String
    func retrieve(forKey key: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        switch status {
        case errSecSuccess:
            guard let data = result as? Data,
                  let token = String(data: data, encoding: .utf8) else {
                throw KeychainError.invalidData
            }
            return token
        case errSecItemNotFound:
            throw KeychainError.itemNotFound
        default:
            throw KeychainError.unknown(status)
        }
    }
    
    /// Elimina un token del Keychain
    /// - Parameter key: La clave del token a eliminar
    func delete(forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknown(status)
        }
    }
    
    /// Elimina todos los items del Keychain (útil para logout)
    func deleteAll() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknown(status)
        }
    }
}

extension KeychainManager {
    
    /// Guarda el token de autenticación
    func saveAuthToken(_ token: String) throws {
        try save(token: token, forKey: Keys.authToken)
    }
    
    /// Recupera el token de autenticación
    func getAuthToken() throws -> String {
        try retrieve(forKey: Keys.authToken)
    }
    
    /// Elimina el token de autenticación
    func deleteAuthToken() throws {
        try delete(forKey: Keys.authToken)
    }
    
    /// Verifica si existe un token de autenticación
    var hasAuthToken: Bool {
        do {
            _ = try getAuthToken()
            return true
        } catch {
            return false
        }
    }
}
