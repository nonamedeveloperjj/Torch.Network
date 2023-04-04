//
//  NetworkError.swift
//  KODE-Sample
//
//  Created by John Snow on 21/10/2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case incorrectResponseType
    case unacceptableStatusCode
}
