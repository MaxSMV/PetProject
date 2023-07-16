//
//  UserDataService.swift
//  TestTask
//
//  Created by Max Stefankiv on 29.03.2023.
//

import Foundation

protocol UserDataServiceProtocol {
    var email: String? { get }
    var password: String? { get }

    func clear()
    func save(password: String)
    func save(email: String)
}

struct UserDataService: UserDataServiceProtocol {
    private enum Constants {
        static let emailKey = "Email"
        static let passwordKey = "Passwd"
    }

    private let userDefaults = UserDefaults.standard

    func clear() {
        KeyChain.delete(key: Constants.passwordKey)
        userDefaults.removeObject(forKey: Constants.emailKey)
        userDefaults.synchronize()
    }

    func save(password: String) {
        KeyChain.save(key: Constants.passwordKey, data: Data(from: password))
    }

    func save(email: String) {
        userDefaults.set(email, forKey: Constants.emailKey)
        userDefaults.synchronize()
    }

    var email: String? {
        userDefaults.string(forKey: Constants.emailKey)
    }

    var password: String? {
        if let passwordKeyData = KeyChain.load(key: Constants.passwordKey) {
            return passwordKeyData.to(type: String.self)
        }
        return nil
    }
}
