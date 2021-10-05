//
//  InspectableTextCellView.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import AppKit

class InspectableTextCellView: NSTableCellView {
    public var stringValue: String {
        get { label.stringValue }
        set { label.stringValue = newValue }
    }
    
    public var alignment: NSTextAlignment {
        get { label.alignment }
        set { label.alignment = newValue }
    }
    
    init() {
        super.init(frame: .zero)
        setupViewHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let label = NSTextField(labelWithString: "").configure {
        $0.maximumNumberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private func setupViewHierarchy() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
