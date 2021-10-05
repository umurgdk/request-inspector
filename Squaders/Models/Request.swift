//
//  Request.swift
//  Squaders
//
//  Created by Umur Gedik on 5.10.2021.
//

import Foundation

class Request: ObservableObject {
    let createdAt: Date
    @Published var state: State
    
    init(createdAt: Date = Date(), state: State = .inProgress) {
        self.createdAt = createdAt
        self.state = state
    }
    
    enum State {
        case inProgress
        case cancelled
        case finished(Response)
        case failed(Failure)
    }
    
    enum Failure: LocalizedError {
        case implementation
        case network(Swift.Error)
        case unexpectedResponse(URLResponse?, Swift.Error?)
        case serverError(URLResponse, Data?, Swift.Error?)
    }
    
    struct Response {
        let statusCode: Int
        let headers: [String: String]
        let squad: Squad
        let inspectableTree: InspectableTree
    }
}
