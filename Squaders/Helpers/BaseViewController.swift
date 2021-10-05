//
//  BaseViewController.swift
//  Squaders
//
//  Created by Umur Gedik on 3.10.2021.
//

import AppKit

class BaseViewController: NSViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = NSView()
        setupViewHierarchy()
    }
    
    func setupViewHierarchy() { }
}
