//
//  HistoryOutlineDataSource.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import AppKit

class HistoryOutlineDataSource: NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {
    public var requests: [Request] = []
    public var onSelect: (Int) -> Void = { _ in }
    
    enum Section: String, CaseIterable { case history = "History" }
    
    func row(forRequestIndex index: Int) -> Int {
        return index + 1
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let section = item as? Section {
            switch section {
            case .history: return requests.count
            }
        } else if item == nil {
            return Section.allCases.count
        }
        
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        guard let section = item as? Section else {
            return Section.allCases[index]
        }
        
        switch section {
        case .history:
            return requests[index]
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return item as? Section != nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        return item as? Section != nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if let section = item as? Section {
            return NSTextField(labelWithString: section.rawValue)
        } else if let request = item as? Request {
            let cellView = outlineView.makeView(withIdentifier: .init("historyCell"), owner: self) as? HistoryCellView ?? HistoryCellView()
            cellView.configure(with: request)
            return cellView
        } else {
            fatalError("Invalid source list item")
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        return item as? Request != nil
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard
            let outlineView = notification.object as? NSOutlineView,
            let selectedItem = outlineView.item(atRow: outlineView.selectedRow)
        else {
            return
        }
        
        let index = outlineView.childIndex(forItem: selectedItem)
        if index >= 0 {
            onSelect(index)
        }
    }
}
