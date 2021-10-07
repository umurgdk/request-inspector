//
//  HistoryViewController.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import AppKit
import Combine

class HistoryViewController: BaseViewController {
    private let appState: AppState
    private var dataSource = HistoryOutlineDataSource()
    private var cancellables: Set<AnyCancellable> = []
    public init(appState: AppState) {
        self.appState = appState
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appState.$requests.sink { [weak self] requests in
            self?.dataSource.requests = requests
            self?.outlineView.reloadData()
        }.store(in: &cancellables)
        
        appState.$selectedRequestIndex.sink { [outlineView, dataSource] index in
            let row = dataSource.row(forRequestIndex: index)
            outlineView.selectRowIndexes([row], byExtendingSelection: false)
        }.store(in: &cancellables)
        
        outlineView.expandItem(HistoryOutlineDataSource.Section.history)
        dataSource.onSelect = { [weak self] index in self?.appState.selectedRequestIndex = index }
    }
    
    // MARK: - View Hierarchy
    lazy var outlineView = NSOutlineView().configure {
        let column = NSTableColumn(identifier: .init("history"))
        $0.addTableColumn(column)
        $0.outlineTableColumn = column
        $0.headerView = nil
        $0.floatsGroupRows = false
        $0.usesAutomaticRowHeights = true
        
        if #available(macOS 11, *) {
            $0.style = .sourceList
        } else {
            $0.selectionHighlightStyle = .sourceList
        }
        
        $0.dataSource = dataSource
        $0.delegate = dataSource
    }
    
    lazy var scrollView = NSScrollView().configure {
        $0.documentView = outlineView
        $0.drawsBackground = false
    }
    
    override func setupViewHierarchy() {
        outlineView.autoresizingMask = [.width, .height]
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
