//
//  URLSession+Extension.swift
//  KODE-Sample
//
//  Created by John Snow on 31/10/2022.
//

import Foundation

// sourcery: AutoMockable
public protocol URLSessionProtocol: AnyObject {
    func data(
        for request: URLRequest,
        delegate: URLSessionTaskDelegate?
    ) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
