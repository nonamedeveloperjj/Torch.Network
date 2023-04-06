//
//  HTTPClient.swift
//  KODE-Sample
//
//  Created by John Snow on 06/10/2022.
//

import Foundation

// sourcery: AutoMockable
public protocol HTTPClientProtocol: AnyObject {
    func sendRequest(requestComponents: RequestComponents) async throws -> Result<Data?, Error>
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
    
    public func sendRequest(requestComponents: RequestComponents) async throws -> Result<Data?, Error> {
        let urlComponents = urlComponentsFactory.create(from: requestComponents)
        
        guard let url = urlComponents.url else {
            return .failure(NetworkError.invalidURL)
        }
        
        let request = urlRequestFactory.create(from: requestComponents, url: url)
        let (data, response) = try await urlSession.data(for: request, delegate: nil)
        
        guard let response = response as? HTTPURLResponse else {
            return .failure(NetworkError.incorrectResponseType)
        }
        
        let acceptableStatusCodes = 200...299
        
        switch response.statusCode {
        case acceptableStatusCodes:
            return .success(data)
        default:
            return .failure(NetworkError.unacceptableStatusCode)
        }
    }
}
