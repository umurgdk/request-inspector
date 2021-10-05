//
//  RequestViewController.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import AppKit
import Combine

class RequestViewController: BaseViewController {
    public var request: Request {
        didSet { viewModel = RequestViewModel(request: request) }
    }
    
    private var viewModel: RequestViewModel {
        didSet {
            if isViewLoaded {
                bindViewModel()
            }
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    init(request: Request) {
        self.request = request
        self.viewModel = RequestViewModel(request: request)
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        cancellables = []
        
        stateView.viewModel = viewModel
        request.$state.sink { [weak self] state in
            if case let .finished(response) = state {
                self?.presentResponseViewController(response: response)
            } else {
                self?.removeResponseViewController()
            }
        }.store(in: &cancellables)
    }
    
    private func presentResponseViewController(response: Request.Response) {
        if let viewController = responseViewController {
            viewController.response = response
            return
        }
        
        let viewController = ResponseViewController(response: response)
        addChild(viewController)
        self.responseViewController = viewController
        
        let responseView = viewController.view
        responseView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(responseView)
        NSLayoutConstraint.activate([
            responseView.topAnchor.constraint(equalTo: stateView.bottomAnchor, constant: 20),
            responseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            responseView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            responseView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func removeResponseViewController() {
        responseViewController?.removeFromParent()
        responseViewController?.view.removeFromSuperview()
        responseViewController = nil
    }

    // MARK: - View Hierarchy
    lazy var stateView = RequestStateView(viewModel: viewModel)
    var responseViewController: ResponseViewController?

    override func setupViewHierarchy() {
        view.addSubview(stateView)
        stateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stateView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
}
