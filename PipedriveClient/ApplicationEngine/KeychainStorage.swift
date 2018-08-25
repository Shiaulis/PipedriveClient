//
//  KeychainStorage.swift
//  PipedriveClient
//
//  Created by Andrius Shiaulis on 25.08.2018.
//  Copyright © 2018 Andrius Shiaulis. All rights reserved.
//

import Foundation

struct Credentials {
    var username: String
    var password: String
}

enum KeychainError: Error {
    case invalidParameters
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

class KeychainStorage {

    // MARK: - Public methods
    func store(credentials: Credentials, for address: String) throws {

        guard credentials.password.count > 0,
        credentials.username.count > 0,
        address.count > 0 else {
            throw KeychainError.invalidParameters
        }

        let username = credentials.username
        guard let password = credentials.password.data(using: String.Encoding.utf8) else {
            throw KeychainError.unexpectedPasswordData
        }

        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: username,
                                    kSecAttrServer as String: address,
                                    kSecValueData as String: password]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    func restoreCredentials(for address: String) throws -> Credentials {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: address,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            throw KeychainError.noPassword
        }

        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)

        }

        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
            else {
                throw KeychainError.unexpectedPasswordData
        }
        
        return Credentials(username: account, password: password)
    }
}
