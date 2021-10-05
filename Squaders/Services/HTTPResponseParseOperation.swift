//
//  HTTPResponseParseOperation.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import Foundation

class HTTPResponseParseOperation: Operation {
    typealias Service = HTTPService
    typealias Result = Swift.Result<Request.Response, Request.Failure>
    
    let httpResponse: HTTPURLResponse
    let data: Data
    
    var completionQueue: OperationQueue
    let parseCompletionBlock: (Result) -> Void
    init(response: HTTPURLResponse, data: Data, completionQueue: OperationQueue = .main, completion: @escaping (Result) -> Void) {
        self.httpResponse = response
        self.data = data
        self.parseCompletionBlock = completion
        self.completionQueue = completionQueue
    }
    
    override func main() {
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            guard
                let object = object,
                let responseString = object["data"] as? String,
                let responseData = responseString.data(using: .utf8)
            else {
                complete(with: .failure(.unexpectedResponse(httpResponse, nil)))
                return
            }
            
            let squad = try JSONDecoder().decode(Squad.self, from: responseData)
            let response = Request.Response(statusCode: httpResponse.statusCode,
                                            headers: httpResponse.allHeaderFields as? [String: String] ?? [:],
                                            squad: squad,
                                            inspectableTree: squad.inspectableTree)
            
            complete(with: .success(response))
        } catch {
            complete(with: .failure(.unexpectedResponse(httpResponse, error)))
        }
    }
    
    private func complete(with result: Result) {
        completionQueue.addOperation {
            self.parseCompletionBlock(result)
        }
    }
}
