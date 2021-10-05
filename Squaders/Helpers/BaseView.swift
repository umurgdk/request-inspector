//
//  BaseView.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import AppKit

class BaseView: NSView {
    init() {
        super.init(frame: .zero)
        setupViewHierarchy()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewHierarchy() { }
}
