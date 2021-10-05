//
//  HistoryCellView.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import AppKit

class HistoryCellView: NSTableCellView {
    init() {
        super.init(frame: .zero)
        setupViewHierarchy()
    }
    
    private let formatter = DateFormatter().configure {
        $0.dateStyle = .long
        $0.timeStyle = .medium
    }
    
    func configure(with request: Request) {
        createdAtLabel.stringValue = formatter.string(from: request.createdAt)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Hierarchy
    private let titleLabel = NSTextField(labelWithString: "Request")
    private let createdAtLabel = NSTextField(labelWithString: "").configure {
        $0.textColor = .secondaryLabelColor
        $0.lineBreakMode = .byTruncatingTail
    }

    private func setupViewHierarchy() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(createdAtLabel)
        createdAtLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            createdAtLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            createdAtLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            createdAtLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            createdAtLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])

    }
}
