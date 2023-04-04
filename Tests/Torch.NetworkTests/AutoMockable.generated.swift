// Generated using Sourcery 1.7.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
import Torch_Network
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif
















class HTTPClientProtocolMock: HTTPClientProtocol {

    //MARK: - sendRequest

    var sendRequestRequestComponentsCompletionCallsCount = 0
    var sendRequestRequestComponentsCompletionCalled: Bool {
        return sendRequestRequestComponentsCompletionCallsCount > 0
    }
    var sendRequestRequestComponentsCompletionReceivedArguments: (requestComponents: RequestComponents, completion: (Result<Data?, Error>) -> Void)?
    var sendRequestRequestComponentsCompletionReceivedInvocations: [(requestComponents: RequestComponents, completion: (Result<Data?, Error>) -> Void)] = []
    var sendRequestRequestComponentsCompletionClosure: ((RequestComponents, @escaping (Result<Data?, Error>) -> Void) -> Void)?

    func sendRequest(requestComponents: RequestComponents, completion: @escaping (Result<Data?, Error>) -> Void) {
        sendRequestRequestComponentsCompletionCallsCount += 1
        sendRequestRequestComponentsCompletionReceivedArguments = (requestComponents: requestComponents, completion: completion)
        sendRequestRequestComponentsCompletionReceivedInvocations.append((requestComponents: requestComponents, completion: completion))
        sendRequestRequestComponentsCompletionClosure?(requestComponents, completion)
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
class URLSessionDataTaskProtocolMock: URLSessionDataTaskProtocol {

    //MARK: - resume

    var resumeCallsCount = 0
    var resumeCalled: Bool {
        return resumeCallsCount > 0
    }
    var resumeClosure: (() -> Void)?

    func resume() {
        resumeCallsCount += 1
        resumeClosure?()
    }

}
class URLSessionProtocolMock: URLSessionProtocol {

    //MARK: - createDataTask

    var createDataTaskWithCompletionHandlerCallsCount = 0
    var createDataTaskWithCompletionHandlerCalled: Bool {
        return createDataTaskWithCompletionHandlerCallsCount > 0
    }
    var createDataTaskWithCompletionHandlerReceivedArguments: (request: URLRequest, completionHandler: (Data?, URLResponse?, Error?) -> Void)?
    var createDataTaskWithCompletionHandlerReceivedInvocations: [(request: URLRequest, completionHandler: (Data?, URLResponse?, Error?) -> Void)] = []
    var createDataTaskWithCompletionHandlerReturnValue: URLSessionDataTaskProtocol!
    var createDataTaskWithCompletionHandlerClosure: ((URLRequest, @Sendable @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol)?

    func createDataTask(with request: URLRequest, completionHandler: @Sendable @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        createDataTaskWithCompletionHandlerCallsCount += 1
        createDataTaskWithCompletionHandlerReceivedArguments = (request: request, completionHandler: completionHandler)
        createDataTaskWithCompletionHandlerReceivedInvocations.append((request: request, completionHandler: completionHandler))
        if let createDataTaskWithCompletionHandlerClosure = createDataTaskWithCompletionHandlerClosure {
            return createDataTaskWithCompletionHandlerClosure(request, completionHandler)
        } else {
            return createDataTaskWithCompletionHandlerReturnValue
        }
    }

}
