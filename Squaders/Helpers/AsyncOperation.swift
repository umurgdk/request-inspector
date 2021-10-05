//
//  AsyncOperation.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import Foundation

class AsyncOperation<Output, Failure: Error>: Operation {
    public var resultCompletionBlock: (Result<Output, Failure>) -> Void = { _ in }
    public var completionQueue: OperationQueue = .main
    
    private enum State: String {
        case ready = "isReady"
        case executing = "isExecuting"
        case finished = "isFinished"
    }
    
    private var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.rawValue)
            willChangeValue(forKey: state.rawValue)
        }
        
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }
    
    override var isReady: Bool { state == .ready && super.isReady }
    override var isExecuting: Bool { state == .executing }
    override var isFinished: Bool { state == .finished }
    
    override var isAsynchronous: Bool { true }
    
    override func start() {
        guard !isCancelled else {
            finish()
            return
        }
        
        if !isExecuting {
            state = .executing
        }
        
        main()
    }
    
    private func finish() {
        if isExecuting {
            state = .finished
        }
    }
    
    func complete(with result: Result<Output, Failure>) {
        finish()
        
        if !isCancelled {
            completionQueue.addOperation {
                self.resultCompletionBlock(result)
            }
        }
    }
}

