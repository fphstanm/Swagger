//
//  DataStore.swift
//  Swagger
//
//  Created by Philip on 12.01.2021.
//

import Foundation

enum DataStoreKeys: String {
    case accessToken = "accessToken"
    case email = "email"
    case password = "password"
}

class DataStore {
    
    private let defaults = UserDefaults.standard
    
    static let shared = DataStore()
    
    static var accessToken: String? {
        return DataStore.shared.read(type: .accessToken)
    }
    
    private init () {}
    
    
    enum Constants: String {
        case accessToken = "accessToken"
        case email = "email"
        case password = "password"
    }

    
    func write(value: String, type: DataStoreKeys) {
        defaults.setValue(value, forKey: type.rawValue)
    }
    
    func read(type: Constants) -> String? {
        defaults.object(forKey: type.rawValue) as? String
    }
}
