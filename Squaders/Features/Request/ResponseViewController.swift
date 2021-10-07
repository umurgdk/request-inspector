//
//  ResponseViewController.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import AppKit

class ResponseViewController: BaseViewController {
    var response: Request.Response {
        didSet { responseDidChange() }
    }
    
    // MARK: - Lifecycle
    private let dataSource: InspectableOutlineDataSource
    init(response: Request.Response) {
        self.response = response
        self.dataSource = InspectableOutlineDataSource(inspectableTree: response.inspectableTree)
        super.init()
    }
    
    private func responseDidChange() {
        self.dataSource.inspectableTree = response.inspectableTree
        outlineView.reloadData()
    }
    
    // MARK: - View Hierarchy
    private lazy var outlineView = NSOutlineView().configure {
        $0.addTableColumn(dataSource.keyColumn)
        $0.addTableColumn(dataSource.typeColumn)
        $0.addTableColumn(dataSource.valueColumn)
        dataSource.typeColumn.width = 35
        
        $0.gridStyleMask = [.solidHorizontalGridLineMask]
        $0.style = .fullWidth
        $0.columnAutoresizingStyle = .noColumnAutoresizing
        $0.outlineTableColumn = dataSource.keyColumn
        $0.indentationMarkerFollowsCell = true
        $0.floatsGroupRows = false
        $0.dataSource = dataSource
        $0.delegate = dataSource
    }
    
    private lazy var scrollView = NSScrollView().configure {
        $0.documentView = outlineView
    }
    
    override func setupViewHierarchy() {
        let divider = NSBox()
        divider.boxType = .separator
        divider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(divider)
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: view.topAnchor),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            scrollView.topAnchor.constraint(equalTo: divider.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
