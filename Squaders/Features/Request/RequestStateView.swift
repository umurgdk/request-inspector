//
//  RequestStateView.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import AppKit
import Combine

class RequestStateView: BaseView {
    public var viewModel: RequestViewModel {
        didSet { bindViewModel() }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    init(viewModel: RequestViewModel) {
        self.viewModel = viewModel
        super.init()
        bindViewModel()
    }
    
    func bindViewModel() {
        cancellables = []
        dateLabel.stringValue = viewModel.createdAtText
        viewModel.stateDidChange.sink { [weak self] in self?.updateUI() }.store(in: &cancellables)
        updateUI()
    }
    
    private func updateUI() {
        stateLabel.stringValue = viewModel.stateText
        activityIndicator.isHidden = !viewModel.isInProgress
        if viewModel.isInProgress {
            activityIndicator.startAnimation(self)
        } else {
            activityIndicator.stopAnimation(self)
        }
        
        statusCodeBox.isHidden = !viewModel.hasStatusCode
        if let statusCode = viewModel.statusCode {
            let color = statusCode == 200 ? NSColor.systemGreen : .systemRed
            statusCodeBox.layer?.backgroundColor = color.cgColor
            statusCodeLabel.stringValue = String(statusCode)
        }
    }
    
    // MARK: - View Hierarchy
    private lazy var activityIndicator = NSProgressIndicator().configure {
        $0.style = .spinning
        $0.controlSize = .small
    }
    
    private lazy var stateLabel = NSTextField(labelWithString: "").configure {
        $0.font = .preferredFont(forTextStyle: .title2, options: [:])
    }
    
    private lazy var dateLabel = NSTextField(labelWithString: "").configure {
        $0.font = .preferredFont(forTextStyle: .subheadline, options: [:])
        $0.textColor = .secondaryLabelColor
    }
    
    private lazy var statusCodeLabel = NSTextField(labelWithString: "").configure {
        $0.font = .monospacedSystemFont(ofSize: 16, weight: .medium)
        $0.textColor = .white
    }
    
    private lazy var statusCodeBox = NSView().configure {
        $0.wantsLayer = true
        $0.layer?.cornerRadius = 6
        $0.layer?.borderColor = CGColor(gray: 0, alpha: 0.1)
        $0.layer?.borderWidth = 1
    }
    
    override var wantsUpdateLayer: Bool { true }
    override func setupViewHierarchy() {
        addSubview(stateLabel)
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(statusCodeBox)
        statusCodeBox.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        statusCodeBox.addSubview(statusCodeLabel)
        statusCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            stateLabel.topAnchor.constraint(equalTo: topAnchor),
            stateLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusCodeBox.leadingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: stateLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: stateLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: stateLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            statusCodeBox.trailingAnchor.constraint(equalTo: trailingAnchor),
            statusCodeBox.topAnchor.constraint(equalTo: topAnchor),
            statusCodeBox.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            statusCodeLabel.trailingAnchor.constraint(equalTo: statusCodeBox.trailingAnchor, constant: -8),
            statusCodeLabel.centerYAnchor.constraint(equalTo: statusCodeBox.centerYAnchor),
            statusCodeLabel.leadingAnchor.constraint(equalTo: statusCodeBox.leadingAnchor, constant: 8),
            
            activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
