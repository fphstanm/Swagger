//
//  ResponseModel.swift
//  Swagger
//
//  Created by Philip on 12.01.2021.
//

import Foundation

class ResponseModel<T: Decodable>: Decodable {
    var success: Bool?
    var description: String?
    var errors: [ResponseError]?
    var data: T?
}

class ResponseError: Decodable, Error {
    var name: String?
    var message: String?
    var code: Int?
    var status: Int?
}
