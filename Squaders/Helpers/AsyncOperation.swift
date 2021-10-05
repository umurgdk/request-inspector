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
    
    private let lockQueue = DispatchQueue(label: "io.umurgdk.squaders.AsyncOperation", attributes: .concurrent)
    private var _state: State = .ready
    private var state: State {
        get { lockQueue.sync { return _state } }
        set {
            let oldValue = lockQueue.sync { return _state }
            
            willChangeValue(forKey: oldValue.rawValue)
            willChangeValue(forKey: newValue.rawValue)
            lockQueue.sync { _state = newValue }
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: newValue.rawValue)
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

