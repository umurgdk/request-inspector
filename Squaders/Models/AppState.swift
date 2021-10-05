//
//  AppState.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import Foundation
import Combine

class AppState {
    // MARK: - Inputs
    @Published public var selectedRequestIndex = 0
    
    // MARK: - Outputs
    @Published public private(set) var requests: [Request] = []
    @Published public private(set) var selectedRequest: Request?
    
    // MARK: - Lifecycle
    private var cancellables: Set<AnyCancellable> = []

    private let httpService: HTTPService
    public init(httpService: HTTPService) {
        self.httpService = httpService
        
        Publishers.CombineLatest($requests, $selectedRequestIndex.removeDuplicates())
            .map { requests, selectedIndex in
                if requests.indices.contains(selectedIndex) {
                    return requests[selectedIndex]
                }
                
                return nil
            }
            .sink { [weak self] in self?.selectedRequest = $0 }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    public func makeRequest(squad: Squad = .sample) {
        let request = Request(createdAt: Date())
        requests.insert(request, at: 0)
        selectedRequestIndex = 0
        
        httpService.sendRequest(data: squad) { result in
            switch result {
            case let .success(response):
                request.state = .finished(response)
            case let .failure(error):
                request.state = .failed(error)
            }
        }
    }
}
