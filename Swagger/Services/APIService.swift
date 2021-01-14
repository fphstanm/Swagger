//
//  NetworkService.swift
//  Swagger
//
//  Created by Philip on 11.01.2021.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol APIService {
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var body: [String: Any]? { get }
    var headers: [String: String]? { get }
    var method: HTTPMethod { get }
}

extension APIService {
    public var urlRequest: URLRequest {
        guard let url = self.url else {
            fatalError("URL could not be built")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if method == .post {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            } catch {
                print("serialization failed")
            }
        }
        
        headers?.forEach { header in
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return request
    }

    private var url: URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path

        if let parameters = parameters as? [String: String] {
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        return urlComponents?.url
    }
}
