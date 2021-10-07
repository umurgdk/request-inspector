//
//  HTTPResponseParseOperation.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import Foundation

fileprivate struct HTTPResponseBody: Decodable {
    let json: Squad
}

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
            let responseBody = try JSONDecoder().decode(HTTPResponseBody.self, from: data)
            
            let squad = responseBody.json
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
