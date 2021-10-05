//
//  HTTPRequestOperation.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import Foundation

class HTTPRequestOperation: AsyncOperation<HTTPRequestOperation.Output, Request.Failure> {
    let urlRequest: URLRequest
    let urlSession: URLSession
    init(session: URLSession, request: URLRequest) {
        self.urlSession = session
        self.urlRequest = request
        super.init()
    }
    
    struct Output {
        let response: HTTPURLResponse
        let data: Data
    }
    
    override func main() {
        urlSession.dataTask(with: urlRequest) { [self] data, response, error in
            if let error = error {
                complete(with: .failure(.network(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                complete(with: .failure(.unexpectedResponse(nil, nil)))
                return
            }
            
            complete(with: .success(Output(response: response, data: data ?? Data())))
        }.resume()
    }
}
