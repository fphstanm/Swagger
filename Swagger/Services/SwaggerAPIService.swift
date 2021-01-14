//
//  Service.swift
//  Swagger
//
//  Created by Philip on 11.01.2021.
//

import Foundation

enum SwaggerAPIService {
    // Auth
    case login(email: String, password: String)
    case signUp(name: String, email: String, password: String)
    // SandBox
    case text(locale: String)
    
    
    var authorizationBearerTokenHeader: [String: String]? {
        guard let token = DataStore.shared.read(type: .accessToken) else { return nil }
        let bearerAccessToken = "Bearer \(token)"
        let httpHeaderField = "Authorization"
        return [httpHeaderField: bearerAccessToken]
    }
}

extension SwaggerAPIService: APIService {
    
    var baseURL: String {
        return "https://apiecho.cf"
    }
    
    var path: String {
        switch self {
        case .login:
            return "/api/login/"
        case .signUp:
            return "/api/signup/"
        case .text:
            return "/api/get/text/"
        }
    }
    
    var parameters: [String : Any]? {
        var tempParams: [String: Any] = [:]

        switch self {
        case .text(let locale):
            tempParams["locale"] = locale
        default:
            return nil
        }

        return tempParams
    }
    
    var body: [String : Any]? {
        var tempParams: [String: Any] = [:]
        
        switch self {
        case .login(let email, let password):
            tempParams["password"] = password
            tempParams["email"] = email
        case .signUp(let name, let email, let password):
            tempParams["name"] = name
            tempParams["email"] = email
            tempParams["password"] = password
        default:
            return nil
        }
        
        return tempParams
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .signUp:
            return .post
            
        case .text:
            return .get
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .text:
            return authorizationBearerTokenHeader
        default:
            return nil
        }
    }
    
}
