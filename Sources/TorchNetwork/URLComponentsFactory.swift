//
//  URLComponentsFactory.swift
//  KODE-Sample
//
//  Created by John Snow on 19/10/2022.
//

import Foundation

// sourcery: AutoMockable
public protocol URLComponentsFactoryProtocol: AnyObject {
    func create(from components: RequestComponents) -> URLComponents
}

final class URLComponentsFactory: URLComponentsFactoryProtocol {
    func create(from requestComponents: RequestComponents) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = requestComponents.scheme
        urlComponents.host = requestComponents.host
        urlComponents.path = requestComponents.path
        
        if let queryItems = requestComponents.queryItems {
            urlComponents.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        return urlComponents
    }
}
