//
//  ContentViewController.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import AppKit

class ContentViewController: BaseViewController {
    public var request: Request? {
        didSet { presentRequest() }
    }
    
    override func viewDidLoad() {
        presentRequest()
    }
    
    private weak var requestViewController: RequestViewController?
    private weak var emptyViewController: EmptyViewController?
    
    private func presentRequest() {
        guard let request = request else {
            if emptyViewController != nil {
                return
            }
            
            requestViewController?.view.removeFromSuperview()
            requestViewController?.removeFromParent()
            requestViewController = nil
            
            let emptyViewContorller = EmptyViewController()
            addChild(emptyViewContorller)
            presentView(emptyViewContorller.view)
            self.emptyViewController = emptyViewContorller
            return
        }
        
        if let requestViewController = requestViewController {
            requestViewController.request = request
        } else {
            emptyViewController?.view.removeFromSuperview()
            emptyViewController?.removeFromParent()
            
            let viewController = RequestViewController(request: request)
            addChild(viewController)
            self.requestViewController = viewController
            presentView(viewController.view)
        }
    }
    
    private func presentView(_ childView: NSView) {
        view.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: view.topAnchor),
            childView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            childView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

fileprivate class EmptyViewController: BaseViewController {
    lazy var emptyLabel = NSTextField(wrappingLabelWithString: "Please select a request or make a new one.").configure {
        $0.font = .preferredFont(forTextStyle: .title2, options: [:])
        $0.textColor = .secondaryLabelColor
    }
    
    override func setupViewHierarchy() {
        view.addSubview(emptyLabel)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -40),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
