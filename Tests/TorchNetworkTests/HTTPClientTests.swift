//
//  HTTPClientTests.swift
//  KODE-SampleTests
//
//  Created by John Snow on 31/10/2022.
//

import XCTest
@testable import TorchNetwork

final class HTTPClientTests: XCTestCase {
    var urlComponentsFactoryMock: URLComponentsFactoryProtocolMock!
    var urlRequestFactoryMock: URLRequestFactoryProtocolMock!
    var urlSessionMock: URLSessionProtocolMock!
    var httpClient: HTTPClient!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        urlComponentsFactoryMock = URLComponentsFactoryProtocolMock()
        urlRequestFactoryMock = URLRequestFactoryProtocolMock()
        urlSessionMock = URLSessionProtocolMock()
        httpClient = HTTPClient(
            urlComponentsFactory: urlComponentsFactoryMock,
            urlRequestFactory: urlRequestFactoryMock,
            urlSession: urlSessionMock
        )
    }
    
    override func tearDownWithError() throws {
        urlComponentsFactoryMock = nil
        urlRequestFactoryMock = nil
        urlSessionMock = nil
        httpClient = nil
        try super.tearDownWithError()
    }
    
    func testRequestIsCompletedWithErrorIfUrlIsIncorrect() async throws {
        // given
        let requestComponents = TestData.requestComponents

        var urlComponents = TestData.urlComponents
        urlComponents?.path = "auth/login"

        urlComponentsFactoryMock.createFromReturnValue = urlComponents

        // when
        let result = try await httpClient.sendRequest(requestComponents: requestComponents)

        // then
        if case .failure(let requestError) = result {
            XCTAssertEqual(requestError as? NetworkError, NetworkError.invalidURL)
        }
    }
    
    func testCorrectRequestIsCompletedWithErrorIfUrlSessionReturnsError() async throws {
        // given
        let requestComponents = TestData.requestComponents
        let stubError: Error = NSError(domain: "", code: 0)
        
        urlComponentsFactoryMock.createFromReturnValue = TestData.urlComponents
        urlRequestFactoryMock.createFromUrlReturnValue = TestData.urlRequest
        
        urlSessionMock.dataForDelegateThrowableError = stubError

        do {
            // when
            _ = try await httpClient.sendRequest(requestComponents: requestComponents)
        } catch {
            // then
            XCTAssertIdentical(error as AnyObject, stubError as AnyObject)
        }
    }
    
    func testRequestIsCompletedWithIncorrectResponseTypeErrorIfResponseHasIncorrectType() async throws {
        // given
        let requestComponents = TestData.requestComponents

        urlComponentsFactoryMock.createFromReturnValue = TestData.urlComponents
        urlRequestFactoryMock.createFromUrlReturnValue = TestData.urlRequest
        
        urlSessionMock.dataForDelegateClosure = { _, _ in
            (Data(), URLResponse())
        }

        // when
        let result = try await httpClient.sendRequest(requestComponents: requestComponents)

        // then
        if case .failure(let obtainedError) = result {
            XCTAssertEqual(obtainedError as? NetworkError, NetworkError.incorrectResponseType)
        }
    }
    
    func testRequestIsCompletedWithUnacceptableStatusCodeIfResponseStatusCodeIsUnacceptable() async throws {
        // given
        let requestComponents = TestData.requestComponents
        let urlResponse = HTTPURLResponse(url: TestData.url!, statusCode: 300, httpVersion: nil, headerFields: nil)!

        urlComponentsFactoryMock.createFromReturnValue = TestData.urlComponents
        urlRequestFactoryMock.createFromUrlReturnValue = TestData.urlRequest
        
        urlSessionMock.dataForDelegateReturnValue = (Data(), urlResponse)

        // when
        let result = try await httpClient.sendRequest(requestComponents: requestComponents)

        // then
        if case .failure(let obtainedError) = result {
            XCTAssertEqual(obtainedError as? NetworkError, NetworkError.unacceptableStatusCode)
        }
    }
    
    func testRequestReturnsDataIfEverythingIsCorrect() async throws {
        // given
        let requestComponents = TestData.requestComponents
        let urlResponse = HTTPURLResponse(url: TestData.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let stubData = Data()

        urlComponentsFactoryMock.createFromReturnValue = TestData.urlComponents
        urlRequestFactoryMock.createFromUrlReturnValue = TestData.urlRequest
        
        urlSessionMock.dataForDelegateReturnValue = (stubData, urlResponse)

        // when
        let result = try await httpClient.sendRequest(requestComponents: requestComponents)

        // then
        if case .success(let obtainedData) = result {
            XCTAssertEqual(obtainedData, stubData)
        }
    }
    
    func testRequestSendsIfURLIsCorrect() async throws {
        // given
        let requestComponents = TestData.requestComponents
        
        let urlComponents = TestData.urlComponents
        urlComponentsFactoryMock.createFromReturnValue = urlComponents
        
        let request = URLRequest(url: urlComponents!.url!)
        urlRequestFactoryMock.createFromUrlReturnValue = request
        
        urlSessionMock.dataForDelegateClosure = { _, _ in
            (Data(), URLResponse())
        }
        
        // when
        _ = try await httpClient.sendRequest(requestComponents: requestComponents)
        
        // then
        XCTAssertEqual(urlComponentsFactoryMock.createFromCallsCount, 1)
        XCTAssertEqual(urlComponentsFactoryMock.createFromReceivedComponents, requestComponents)
        
        XCTAssertEqual(urlRequestFactoryMock.createFromUrlCallsCount, 1)
        XCTAssertEqual(urlRequestFactoryMock.createFromUrlReceivedArguments!.requestComponents, requestComponents)
        XCTAssertEqual(urlRequestFactoryMock.createFromUrlReceivedArguments!.url, urlComponents?.url!)
        
        XCTAssertEqual(urlSessionMock.dataForDelegateCallsCount, 1)
        XCTAssertEqual(
            urlSessionMock.dataForDelegateReceivedArguments!.request,
            urlRequestFactoryMock.createFromUrlReturnValue
        )
    }
}

private extension HTTPClientTests {
    enum TestData {
        static let requestComponents = RequestComponents(
            scheme: "https",
            host: "example.com",
            path: "path",
            method: .get,
            header: ["Content-Type": "application/json"],
            body: ["key1": "value1", "key2": "value2"]
        )
        static let urlComponents = URLComponents(string: "https://example.com")
        static let urlRequest = URLRequest(url: url!)
        static let url = URL(string: "https://example.com")
    }
}
