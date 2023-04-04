//
//  URLComponentsFactoryTests.swift
//  KODE-SampleTests
//
//  Created by John Snow on 31/10/2022.
//

import XCTest
@testable import Torch_Network

final class URLComponentsFactoryTests: XCTestCase {
    var urlComponentsFactory: URLComponentsFactory!

    override func setUpWithError() throws {
        try super.setUpWithError()
        urlComponentsFactory = URLComponentsFactory()
    }

    override func tearDownWithError() throws {
        urlComponentsFactory = nil
        try super.tearDownWithError()
    }
    
    func testCreatedURLComponentsAreCorrect() {
        // given
        let requestComponents = RequestComponents(
            scheme: "https",
            host: "example.com",
            path: "path",
            method: .get,
            header: ["Content-Type": "application/json"],
            queryItems: ["key1": "value1", "key2": "value2"],
            body: ["key1": "value1", "key2": "value2"]
        )
        
        let givenQueryItems = requestComponents.queryItems!.map { URLQueryItem(name: $0.key, value: $0.value) }
        let createdUrlComponents: URLComponents
        
        // when
        createdUrlComponents = urlComponentsFactory.create(from: requestComponents)
        
        // then
        XCTAssertEqual(createdUrlComponents.scheme, requestComponents.scheme)
        XCTAssertEqual(createdUrlComponents.host, requestComponents.host)
        XCTAssertEqual(createdUrlComponents.path, requestComponents.path)
        
        let sortedCreatedQueryItems = createdUrlComponents.queryItems!.sorted(by: { $0.name < $1.name })
        let sortedGivenQueryItems = givenQueryItems.sorted(by: { $0.name < $1.name })
        XCTAssertTrue(sortedCreatedQueryItems.elementsEqual(sortedGivenQueryItems))
    }
}
