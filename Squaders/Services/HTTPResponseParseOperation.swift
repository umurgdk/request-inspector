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
    let parseCompletionBlock: (Result) -> Void
    
    init(response: HTTPURLResponse, data: Data, completion: @escaping (Result) -> Void) {
        self.httpResponse = response
        self.data = data
        self.parseCompletionBlock = completion
    }
    
    override func main() {
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            guard
                let object = object,
                let responseString = object["data"] as? String,
                let responseData = responseString.data(using: .utf8)
            else {
                parseCompletionBlock(.failure(.unexpectedResponse(httpResponse, nil)))
                return
            }
            
            let squad = try JSONDecoder().decode(Squad.self, from: responseData)
            let response = Request.Response(statusCode: httpResponse.statusCode,
                                            headers: httpResponse.allHeaderFields as? [String: String] ?? [:],
                                            squad: squad,
                                            inspectableTree: squad.inspectableTree)
            
            parseCompletionBlock(.success(response))
        } catch {
            parseCompletionBlock(.failure(.unexpectedResponse(httpResponse, error)))
        }
    }
}
