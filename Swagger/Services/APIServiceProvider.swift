//
//  ServiceProvider.swift
//  Swagger
//
//  Created by Philip on 11.01.2021.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
    case empty
}

enum CustomResult<T> {
    case success(T)
    case failure([Error])
    case empty
}

class CustomError {
    var response: Decodable
    
    init<T: Decodable>(model: T) {
        self.response = model
    }
    
}

class ServiceProvider<T: APIService> {
    
    var urlSession = URLSession.shared

    init() { }

    func load<U: Decodable>(service: T, decodeType: ResponseModel<U>.Type, completion: @escaping (CustomResult<U>) -> Void) {
        print(service.urlRequest)
        
        call(service.urlRequest) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(decodeType, from: data)
                    
                    if response.success ?? false {
                        completion(.success(response.data!))
                    } else {
                        completion(.failure(response.errors ?? []))
                    }
                }
                catch {
                    completion(.failure([error]))
                }
            case .failure(let error):
                completion(.failure([error]))
            case .empty:
                completion(.empty)
            }
        }
    }

}

extension ServiceProvider {
    private func call(_ request: URLRequest, deliverQueue: DispatchQueue = DispatchQueue.main, completion: @escaping (Result<Data>) -> Void) {
        urlSession.dataTask(with: request) { (data, _, error) in
            if let error = error {
                deliverQueue.async {
                    completion(.failure(error))
                }
            } else if let data = data {
                deliverQueue.async {
                    completion(.success(data))
                }
            } else {
                deliverQueue.async {
                    completion(.empty)
                }
            }
            }.resume()
    }
    
}
