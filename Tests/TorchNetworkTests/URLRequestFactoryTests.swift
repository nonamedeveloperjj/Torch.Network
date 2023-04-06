//
//  URLRequestFactoryTests.swift
//  KODE-SampleTests
//
//  Created by John Snow on 28/10/2022.
//

import XCTest
@testable import TorchNetwork

final class URLRequestFactoryTests: XCTestCase {
    var urlRequestFactory: URLRequestFactory!

    override func setUpWithError() throws {
        try super.setUpWithError()
        urlRequestFactory = URLRequestFactory()
    }

    override func tearDownWithError() throws {
        urlRequestFactory = nil
        try super.tearDownWithError()
    }

    func testCreatedURLRequestIsCorrect() {
        // given
        let requestComponents = RequestComponents(
            scheme: "https",
            host: "example.com",
            path: "path",
            method: .get,
            header: ["Content-Type": "application/json"],
            body: ["key1": "value1", "key2": "value2"]
        )
        
        let serializedBody = try! JSONSerialization.data(withJSONObject: requestComponents.body!, options: [])
        
        let url = URL(string: "https://example.com/path")
        let createdURLRequest: URLRequest
        
        // when
        createdURLRequest = urlRequestFactory.create(from: requestComponents, url: url!)
        
        // then
        XCTAssertEqual(createdURLRequest.url, url)
        XCTAssertEqual(createdURLRequest.httpMethod, requestComponents.method.rawValue)
        XCTAssertEqual(createdURLRequest.allHTTPHeaderFields, requestComponents.header)
        XCTAssertEqual(createdURLRequest.httpBody, serializedBody)
    }
}
