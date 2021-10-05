//
//  BrowserViewController.swift
//  Squaders
//
//  Created by Umur Gedik on 3.10.2021.
//

import AppKit
import Combine

class BrowserViewController: BaseViewController {
    private let appState: AppState
    private var cancellables: Set<AnyCancellable> = []
    public init(appState: AppState) {
        self.appState = appState
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appState.$selectedRequest.assign(to: \.request, on: contentViewController).store(in: &cancellables)
        appState.$selectedRequest.compactMap { $0 }.sink { [weak self] request in
            guard let window = self?.view.window else { return }
            window.title = "Request"
            window.subtitle = RequestViewModel(request: request).createdAtText
        }.store(in: &cancellables)
    }
    
    // MARK: - View Hierarchy
    lazy var historyViewController = HistoryViewController(appState: appState)
    lazy var contentViewController = ContentViewController()
    lazy var splitViewController = NSSplitViewController().configure {
        let sidebarItem = NSSplitViewItem(sidebarWithViewController: historyViewController)
        sidebarItem.minimumThickness = 200
        $0.addSplitViewItem(sidebarItem)
        
        let contentItem = NSSplitViewItem(viewController: contentViewController)
        $0.addSplitViewItem(contentItem)
    }
    
    override func setupViewHierarchy() {
        addChild(splitViewController)
        view.addSubview(splitViewController.view)
        
        let childView = splitViewController.view
        childView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: view.topAnchor),
            childView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            childView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

