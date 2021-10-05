//
//  HTTPService.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import Foundation

class HTTPService {
    private static let remoteURL: URL = URL(string: "https://httpbin.org/anything")!
            
    private let requestQueue = OperationQueue().configure {
        $0.maxConcurrentOperationCount = 4
        $0.qualityOfService = .userInitiated
    }
    
    private let parseQueue = OperationQueue().configure {
        $0.qualityOfService = .userInitiated
    }
    
    private let urlSession: URLSession
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func sendRequest(data: Squad, _ completion: @escaping (Result<Request.Response, Request.Failure>) -> Void) {
        let request: URLRequest
        do {
            request = try urlRequest(forData: data)
        } catch {
            completion(.failure(.implementation))
            return
        }
        
        let requestOperation = HTTPRequestOperation(session: urlSession, request: request)
        requestOperation.resultCompletionBlock = { [self] result in
            switch result {
            case let .success(output):
                let parseOperation = HTTPResponseParseOperation(response: output.response, data: output.data) { parseResult in
                    switch parseResult {
                    case let .success(response):
                        complete(completion, with: .success(response))
                    case let .failure(error):
                        complete(completion, with: .failure(error))
                    }
                }
                
                parseQueue.addOperation(parseOperation)
            case let .failure(error):
                self.complete(completion, with: .failure(error))
            }
        }
        
        requestQueue.addOperation(requestOperation)
    }
    
    private func complete(_ completion: @escaping (Result<Request.Response, Request.Failure>) -> Void, with result: Result<Request.Response, Request.Failure>) {
        OperationQueue.main.addOperation {
            completion(result)
        }
    }
    
    private func urlRequest(forData data: Squad) throws -> URLRequest {
        var request = URLRequest(url: Self.remoteURL)
        request.httpBody = try JSONEncoder().encode(data)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        return request
    }
}
