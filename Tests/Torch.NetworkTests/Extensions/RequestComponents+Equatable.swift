//
//  RequestComponents+Equatable.swift
//  KODE-SampleTests
//
//  Created by John Snow on 31/10/2022.
//

import Foundation
@testable import Torch_Network

extension RequestComponents: Equatable {
    public static func == (lhs: RequestComponents, rhs: RequestComponents) -> Bool {
        return
            lhs.scheme == rhs.scheme &&
            lhs.host == rhs.host &&
            lhs.path == rhs.path &&
            lhs.method == rhs.method &&
            lhs.header == rhs.header &&
            lhs.queryItems == rhs.queryItems &&
            lhs.body == rhs.body
    }
}
