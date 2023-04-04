//
//  HTTPClient.swift
//  KODE-Sample
//
//  Created by John Snow on 06/10/2022.
//

import Foundation

// sourcery: AutoMockable
public protocol HTTPClientProtocol: AnyObject {
    func sendRequest(requestComponents: RequestComponents, completion: @escaping (Result<Data?, Error>) -> Void)
}

public final class HTTPClient: HTTPClientProtocol {
    private let urlComponentsFactory: URLComponentsFactoryProtocol
    private let urlRequestFactory: URLRequestFactoryProtocol
    private let urlSession: URLSessionProtocol
    
    init(
        urlComponentsFactory: URLComponentsFactoryProtocol,
        urlRequestFactory: URLRequestFactoryProtocol,
        urlSession: URLSessionProtocol
    ) {
        self.urlComponentsFactory = urlComponentsFactory
        self.urlRequestFactory = urlRequestFactory
        self.urlSession = urlSession
    }
    
    public func sendRequest(requestComponents: RequestComponents, completion: @escaping (Result<Data?, Error>) -> Void) {
        let urlComponents = urlComponentsFactory.create(from: requestComponents)
        
        guard let url = urlComponents.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let request = urlRequestFactory.create(from: requestComponents, url: url)
        
        urlSession.createDataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.incorrectResponseType))
                return
            }
            
            let acceptableStatusCodes = 200...299
            
            switch response.statusCode {
            case acceptableStatusCodes:
                completion(.success(data))
            default:
                completion(.failure(NetworkError.unacceptableStatusCode))
            }
        }.resume()
    }
}
