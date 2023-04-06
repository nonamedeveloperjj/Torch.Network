// Generated using Sourcery 1.7.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
@testable import TorchNetwork
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif
















class HTTPClientProtocolMock: HTTPClientProtocol {

    //MARK: - sendRequest

    var sendRequestRequestComponentsThrowableError: Error?
    var sendRequestRequestComponentsCallsCount = 0
    var sendRequestRequestComponentsCalled: Bool {
        return sendRequestRequestComponentsCallsCount > 0
    }
    var sendRequestRequestComponentsReceivedRequestComponents: RequestComponents?
    var sendRequestRequestComponentsReceivedInvocations: [RequestComponents] = []
    var sendRequestRequestComponentsReturnValue: Result<Data?, Error>!
    var sendRequestRequestComponentsClosure: ((RequestComponents) async throws -> Result<Data?, Error>)?

    func sendRequest(requestComponents: RequestComponents) async throws -> Result<Data?, Error> {
        if let error = sendRequestRequestComponentsThrowableError {
            throw error
        }
        sendRequestRequestComponentsCallsCount += 1
        sendRequestRequestComponentsReceivedRequestComponents = requestComponents
        sendRequestRequestComponentsReceivedInvocations.append(requestComponents)
        if let sendRequestRequestComponentsClosure = sendRequestRequestComponentsClosure {
            return try await sendRequestRequestComponentsClosure(requestComponents)
        } else {
            return sendRequestRequestComponentsReturnValue
        }
    }

}
class URLComponentsFactoryProtocolMock: URLComponentsFactoryProtocol {

    //MARK: - create

    var createFromCallsCount = 0
    var createFromCalled: Bool {
        return createFromCallsCount > 0
    }
    var createFromReceivedComponents: RequestComponents?
    var createFromReceivedInvocations: [RequestComponents] = []
    var createFromReturnValue: URLComponents!
    var createFromClosure: ((RequestComponents) -> URLComponents)?

    func create(from components: RequestComponents) -> URLComponents {
        createFromCallsCount += 1
        createFromReceivedComponents = components
        createFromReceivedInvocations.append(components)
        if let createFromClosure = createFromClosure {
            return createFromClosure(components)
        } else {
            return createFromReturnValue
        }
    }

}
class URLRequestFactoryProtocolMock: URLRequestFactoryProtocol {

    //MARK: - create

    var createFromUrlCallsCount = 0
    var createFromUrlCalled: Bool {
        return createFromUrlCallsCount > 0
    }
    var createFromUrlReceivedArguments: (requestComponents: RequestComponents, url: URL)?
    var createFromUrlReceivedInvocations: [(requestComponents: RequestComponents, url: URL)] = []
    var createFromUrlReturnValue: URLRequest!
    var createFromUrlClosure: ((RequestComponents, URL) -> URLRequest)?

    func create(from requestComponents: RequestComponents, url: URL) -> URLRequest {
        createFromUrlCallsCount += 1
        createFromUrlReceivedArguments = (requestComponents: requestComponents, url: url)
        createFromUrlReceivedInvocations.append((requestComponents: requestComponents, url: url))
        if let createFromUrlClosure = createFromUrlClosure {
            return createFromUrlClosure(requestComponents, url)
        } else {
            return createFromUrlReturnValue
        }
    }

}
class URLSessionProtocolMock: URLSessionProtocol {

    //MARK: - data

    var dataForDelegateThrowableError: Error?
    var dataForDelegateCallsCount = 0
    var dataForDelegateCalled: Bool {
        return dataForDelegateCallsCount > 0
    }
    var dataForDelegateReceivedArguments: (request: URLRequest, delegate: URLSessionTaskDelegate?)?
    var dataForDelegateReceivedInvocations: [(request: URLRequest, delegate: URLSessionTaskDelegate?)] = []
    var dataForDelegateReturnValue: (Data, URLResponse)!
    var dataForDelegateClosure: ((URLRequest, URLSessionTaskDelegate?) async throws -> (Data, URLResponse))?

    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        if let error = dataForDelegateThrowableError {
            throw error
        }
        dataForDelegateCallsCount += 1
        dataForDelegateReceivedArguments = (request: request, delegate: delegate)
        dataForDelegateReceivedInvocations.append((request: request, delegate: delegate))
        if let dataForDelegateClosure = dataForDelegateClosure {
            return try await dataForDelegateClosure(request, delegate)
        } else {
            return dataForDelegateReturnValue
        }
    }

}
