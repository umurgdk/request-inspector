//
//  HTTPService.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import Foundation

class HTTPService {
    private static let remoteURL: URL = URL(string: "https://httpbin.org/anything")!
            
    private let parseQueue = OperationQueue().configure {
        $0.qualityOfService = .userInitiated
    }
    
    private let urlSession: URLSession
    init(urlSession: URLSession? = nil, maximumConcurrentConnections: Int? = nil) {
        if let session = urlSession {
            self.urlSession = session
        } else {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            configuration.httpCookieStorage = nil
            
            if let maximumConnections = maximumConcurrentConnections {
                configuration.httpMaximumConnectionsPerHost = maximumConnections
            }
            
            self.urlSession = URLSession(configuration: configuration)
        }
    }
    
    public func sendRequest(data: Squad, _ completion: @escaping (Result<Request.Response, Request.Failure>) -> Void) {
        let request: URLRequest
        do {
            request = try urlRequest(forData: data)
        } catch {
            completion(.failure(.implementation))
            return
        }
        
        dataTask(for: request) { [self] result in
            switch result {
            case let .success((response, data)):
                let parseOperation = HTTPResponseParseOperation(response: response, data: data) { parseResult in
                    switch parseResult {
                    case let .success(response):
                        complete(completion, with: .success(response))
                    case let .failure(error):
                        complete(completion, with: .failure(error))
                    }
                }
                
                parseQueue.addOperation(parseOperation)
            case let .failure(error):
                complete(completion, with: .failure(error))
            }
        }
    }
    
    private func complete(_ completion: @escaping (Result<Request.Response, Request.Failure>) -> Void, with result: Result<Request.Response, Request.Failure>) {
        OperationQueue.main.addOperation {
            completion(result)
        }
    }
    
    private func dataTask(for request: URLRequest, _ completion: @escaping (Result<(HTTPURLResponse, Data), Request.Failure>) -> Void) {
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error  {
                completion(.failure(.network(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  let data = data
            else {
                completion(.failure(.unexpectedResponse(response, nil)))
                return
            }
            
            completion(.success((httpResponse, data)))
        }.resume()
    }
    
    private func urlRequest(forData data: Squad) throws -> URLRequest {
        var request = URLRequest(url: Self.remoteURL)
        request.httpBody = try JSONEncoder().encode(data)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        return request
    }
}
