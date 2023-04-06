//
//  RequestComponents.swift
//  KODE-Sample
//
//  Created by John Snow on 13/10/2022.
//

import Foundation

public struct RequestComponents {
    let scheme: String
    let host: String
    let path: String
    let method: RequestMethod
    let header: [String: String]?
    let queryItems: [String: String]?
    let body: [String: String]?
    
    public init(
        scheme: String,
        host: String,
        path: String,
        method: RequestMethod,
        header: [String : String]?,
        queryItems: [String : String]? = nil,
        body: [String : String]? = nil
    ) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.method = method
        self.header = header
        self.queryItems = queryItems
        self.body = body
    }
}
