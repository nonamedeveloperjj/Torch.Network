//
//  URLSessionDataTask+Extension.swift
//  KODE-Sample
//
//  Created by John Snow on 01/11/2022.
//

import Foundation

// sourcery: AutoMockable
public protocol URLSessionDataTaskProtocol: AnyObject {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
