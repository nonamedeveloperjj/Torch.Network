//
//  HTTPClientTests.swift
//  KODE-SampleTests
//
//  Created by John Snow on 31/10/2022.
//

import XCTest
@testable import Torch_Network

final class HTTPClientTests: XCTestCase {
    var urlComponentsFactoryMock: URLComponentsFactoryProtocolMock!
    var urlRequestFactoryMock: URLRequestFactoryProtocolMock!
    var urlSessionMock: URLSessionProtocolMock!
    var urlSessionDataTaskMock: URLSessionDataTaskProtocolMock!
    var httpClient: HTTPClient!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        urlComponentsFactoryMock = URLComponentsFactoryProtocolMock()
        urlRequestFactoryMock = URLRequestFactoryProtocolMock()
        urlSessionMock = URLSessionProtocolMock()
        urlSessionDataTaskMock = URLSessionDataTaskProtocolMock()
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
        urlSessionDataTaskMock = nil
        httpClient = nil
        try super.tearDownWithError()
    }
    
    func testRequestIsCompletedWithErrorIfUrlIsIncorrect() {
        // given
        let requestComponents = TestData.requestComponents
        var requestError: Error?

        var urlComponents = TestData.urlComponents
        urlComponents?.path = "auth/login"

        urlComponentsFactoryMock.createFromReturnValue = urlComponents

        // when
        httpClient.sendRequest(requestComponents: requestComponents, completion: { result in
            if case let .failure(error) = result {
                requestError = error
            }
        })

        // then
        XCTAssertEqual(requestError as? NetworkError, NetworkError.invalidURL)
    }
    
    func testCorrectRequestIsCompletedWithErrorIfUrlSessionReturnsError() {
        // given
        let requestComponents = TestData.requestComponents
        let stubError: Error = NSError(domain: "", code: 0)
        var obtainedError: Error?
        
        urlComponentsFactoryMock.createFromReturnValue = TestData.urlComponents
        urlRequestFactoryMock.createFromUrlReturnValue = TestData.urlRequest
        
        urlSessionMock.createDataTaskWithCompletionHandlerClosure = { [unowned self] _, completionHandler in
            completionHandler(nil, nil, stubError)
            return self.urlSessionDataTaskMock
        }
        
        // when
        httpClient.sendRequest(requestComponents: requestComponents) { result in
            if case let .failure(error) = result {
                obtainedError = error
            }
        }
        
        // then
        XCTAssertIdentical(obtainedError as AnyObject, stubError as AnyObject)
        
    }
    
    func testRequestIsCompletedWithIncorrectResponseTypeErrorIfResponseHasIncorrectType() {
        // given
        let requestComponents = TestData.requestComponents
        var obtainedError: Error?

        urlComponentsFactoryMock.createFromReturnValue = TestData.urlComponents
        urlRequestFactoryMock.createFromUrlReturnValue = TestData.urlRequest
        
        urlSessionMock.createDataTaskWithCompletionHandlerClosure = { [unowned self] _, completionHandler in
            completionHandler(nil, URLResponse(), nil)
            return self.urlSessionDataTaskMock
        }

        // when
        httpClient.sendRequest(requestComponents: requestComponents) { result in
            if case let .failure(error) = result {
                obtainedError = error
            }
        }

        // then
        XCTAssertEqual(obtainedError as? NetworkError, NetworkError.incorrectResponseType)
    }
    
    func testRequestIsCompletedWithUnacceptableStatusCodeIfResponseStatusCodeIsUnacceptable() {
        // given
        let requestComponents = TestData.requestComponents
        let urlResponse = HTTPURLResponse(url: TestData.url!, statusCode: 300, httpVersion: nil, headerFields: nil)
        var obtainedError: Error?

        urlComponentsFactoryMock.createFromReturnValue = TestData.urlComponents
        urlRequestFactoryMock.createFromUrlReturnValue = TestData.urlRequest
        
        urlSessionMock.createDataTaskWithCompletionHandlerClosure = { [unowned self] _, completionHandler in
            completionHandler(nil, urlResponse, nil)
            return self.urlSessionDataTaskMock
        }

        // when
        httpClient.sendRequest(requestComponents: requestComponents) { result in
            if case let .failure(error) = result {
                obtainedError = error
            }
        }

        // then
        XCTAssertEqual(obtainedError as? NetworkError, NetworkError.unacceptableStatusCode)
    }
    
    func testRequestReturnsDataIfEverythingIsCorrect() {
        // given
        let requestComponents = TestData.requestComponents
        let urlResponse = HTTPURLResponse(url: TestData.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let stubData = Data()
        var obtainedData: Data?

        urlComponentsFactoryMock.createFromReturnValue = TestData.urlComponents
        urlRequestFactoryMock.createFromUrlReturnValue = TestData.urlRequest
        
        urlSessionMock.createDataTaskWithCompletionHandlerClosure = { [unowned self] _, completionHandler in
            completionHandler(stubData, urlResponse, nil)
            return self.urlSessionDataTaskMock
        }

        // when
        httpClient.sendRequest(requestComponents: requestComponents) { result in
            if case let .success(data) = result {
                obtainedData = data
            }
        }

        // then
        XCTAssertEqual(obtainedData, stubData)
    }
    
    func testRequestSendsIfURLIsCorrect() {
        // given
        let requestComponents = TestData.requestComponents
        
        let urlComponents = TestData.urlComponents
        urlComponentsFactoryMock.createFromReturnValue = urlComponents
        
        let request = URLRequest(url: urlComponents!.url!)
        urlRequestFactoryMock.createFromUrlReturnValue = request
        
        urlSessionMock.createDataTaskWithCompletionHandlerClosure = { [unowned self] _, _ in
            self.urlSessionDataTaskMock
        }
        
        // when
        httpClient.sendRequest(requestComponents: requestComponents, completion: { _ in })
        
        // then
        XCTAssertEqual(urlComponentsFactoryMock.createFromCallsCount, 1)
        XCTAssertEqual(urlComponentsFactoryMock.createFromReceivedComponents, requestComponents)
        
        XCTAssertEqual(urlRequestFactoryMock.createFromUrlCallsCount, 1)
        XCTAssertEqual(urlRequestFactoryMock.createFromUrlReceivedArguments!.requestComponents, requestComponents)
        XCTAssertEqual(urlRequestFactoryMock.createFromUrlReceivedArguments!.url, urlComponents?.url!)
        
        XCTAssertEqual(urlSessionMock.createDataTaskWithCompletionHandlerCallsCount, 1)
        XCTAssertEqual(
            urlSessionMock.createDataTaskWithCompletionHandlerReceivedArguments!.request,
            urlRequestFactoryMock.createFromUrlReturnValue
        )
        XCTAssertEqual(urlSessionDataTaskMock.resumeCallsCount, 1)
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
