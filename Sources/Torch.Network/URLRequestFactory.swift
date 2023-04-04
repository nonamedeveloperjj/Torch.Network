//
//  URLRequestFactory.swift
//  KODE-Sample
//
//  Created by John Snow on 19/10/2022.
//

import Foundation

// sourcery: AutoMockable
public protocol URLRequestFactoryProtocol: AnyObject {
    func create(from requestComponents: RequestComponents, url: URL) -> URLRequest
}

final class URLRequestFactory: URLRequestFactoryProtocol {
    func create(from requestComponents: RequestComponents, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = requestComponents.method.rawValue
        request.allHTTPHeaderFields = requestComponents.header
        
        if let body = requestComponents.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        return request
    }
}
