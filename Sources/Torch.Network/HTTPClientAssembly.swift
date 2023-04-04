//
//  HTTPClientAssembly.swift
//  KODE-Sample
//
//  Created by John Snow on 19/10/2022.
//

import Foundation

public final class HTTPClientAssembly {
    public init() {}
    
    public func create() -> HTTPClient {
        let urlCompoentsFactory = URLComponentsFactory()
        let urlRequestFactory = URLRequestFactory()
        let urlSession = URLSession.shared
        
        return HTTPClient(
            urlComponentsFactory: urlCompoentsFactory,
            urlRequestFactory: urlRequestFactory,
            urlSession: urlSession
        )
    }
}
