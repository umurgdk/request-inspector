//
//  RequestViewModel.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import Foundation
import Combine

class RequestViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let request: Request
    private let dateFormatter = DateFormatter().configure {
        $0.timeStyle = .medium
        $0.dateStyle = .long
    }
    
    private var state: Request.State {
        didSet { stateDidChangeSubject.send() }
    }
    
    private let stateDidChangeSubject = PassthroughSubject<(), Never>()
    public var stateDidChange: AnyPublisher<(), Never> { stateDidChangeSubject.eraseToAnyPublisher() }
    
    public init(request: Request) {
        self.request = request
        self.state = request.state
        stateDidChangeSubject.send()
        request.$state.sink { [weak self] in self?.state = $0 }.store(in: &cancellables)
    }
    
    // MARK: - Outputs
    public var stateText: String { state.informativeText }
    public var statusCode: Int? { state.statusCode }
    public var hasStatusCode: Bool { state.hasStatusCode }
    public var isInProgress: Bool { state.isInProgress }
    public var createdAtText: String {
        dateFormatter.string(from: request.createdAt)
    }
}

fileprivate extension Request.State {
    var statusCode: Int? {
        if case let .failed(.unexpectedResponse(response?, _)) = self {
            return (response as? HTTPURLResponse)?.statusCode
        } else if case let .finished(response) = self {
            return response.statusCode
        }
        
        return nil
    }
    
    var hasStatusCode: Bool { statusCode != nil }
    var isInProgress: Bool {
        if case .inProgress = self {
            return true
        }
        
        return false
    }
    
    var informativeText: String {
        switch self {
        case .cancelled:
            return "Request has been cancelled."
        case .failed(let error):
            if case .unexpectedResponse(let response, _) = error, response != nil {
                return "Server returned non successful response"
            }
            
            return "Failed to make request"
            
        case .inProgress:
            return "Request is in progress."
            
        case .finished:
            return "Request is finished."
        }
    }
}
