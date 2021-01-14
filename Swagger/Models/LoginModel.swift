//
//  LoginModel.swift
//  Swagger
//
//  Created by Philip on 11.01.2021.
//

import Foundation

class LoginModel: Decodable {
    var uid: Int?
    var name: String?
    var email: String?
    var accessToken: String?
    var role: Int?
    var status: Int?
    var createdAt: Int?
    var updatedAt: Int?

    enum CodingKeys: String, CodingKey {
        case uid, name, email, role, status
        case accessToken = "access_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
