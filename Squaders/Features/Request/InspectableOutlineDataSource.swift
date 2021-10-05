//
//  InspectableOutlineDataSource.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import AppKit

class InspectableOutlineDataSource: NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {
    public var inspectableTree: InspectableTree
    public init(inspectableTree: InspectableTree) {
        self.inspectableTree = inspectableTree
        super.init()
    }
    
    public var keyColumn = NSTableColumn(identifier: .init("InspectableKey")).configure {
        $0.title = "Key or Index"
    }
    
    public var typeColumn = NSTableColumn(identifier: .init("InspectableType")).configure {
        $0.title = "Type"
    }
    
    public var valueColumn = NSTableColumn(identifier: .init("InspectableValue")).configure {
        $0.title = "Value"
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            return 1
        }
        
        if let tree = item as? InspectableTree {
            return tree.numberOfChildren
        }
        
        let value: InspectableValue
        if let property = item as? InspectableProperty {
            value = property.value
        } else if let itemValue = item as? InspectableValue {
            value = itemValue
        } else {
            fatalError("Invalid outline item")
        }

        switch value.value {
        case .array(let array):
            return array.numberOfChildren
        case .object(let inspectableTree):
            return inspectableTree.numberOfChildren
        default:
            return 0
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            return inspectableTree
        }
        
        if let tree = item as? InspectableTree {
            return tree.children[index]
        }
        
        let value: InspectableValue
        if let property = item as? InspectableProperty {
            value = property.value
        } else if let itemValue = item as? InspectableValue {
            value = itemValue
        } else {
            fatalError("Invalid outline item")
        }
        
        switch value.value {
        case .array(let array):
            return array.children[index]
        case .object(let inspectableTree):
            return inspectableTree.children[index]
        default:
            fatalError("Invalid outline item")
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let _ = item as? InspectableTree {
            return true
        } else if let _ = item as? InspectableArray {
            return true
        }
        
        let value: InspectableValue
        if let property = item as? InspectableProperty {
            value = property.value
        } else if let itemValue = item as? InspectableValue {
            value = itemValue
        } else {
            fatalError("Invalid outline item")
        }

        switch value.value {
        case .array, .object: return true
        default:
            return false
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let cellView = outlineView.makeView(withIdentifier: .init("inspectableCell"), owner: self) as? InspectableTextCellView ?? InspectableTextCellView()
        cellView.identifier = .init("inspectableCell")

        switch tableColumn {
        case keyColumn:
            return keyView(for: cellView, outlineView: outlineView, item: item)
        case typeColumn:
            return typeView(for: cellView, item: item)
        case valueColumn:
            return valueView(for: cellView, item: item)
        default:
            fatalError("Invalid outline column")
        }
    }
    
    private func keyView(for cellView: InspectableTextCellView, outlineView: NSOutlineView, item: Any) -> NSView {
        cellView.alignment = .left
        if let tree = item as? InspectableTree {
            cellView.stringValue = tree.name
            return cellView
        } else if let property = item as? InspectableProperty {
            cellView.stringValue = property.name
            return cellView
        }
        
        guard let inspectable = item as? InspectableValue else { fatalError("Invalid outline item") }
        
        let itemIndex = outlineView.childIndex(forItem: inspectable)
        cellView.stringValue = "Index \(itemIndex)"
        return cellView
    }
    
    private func typeView(for cellView: InspectableTextCellView, item: Any) -> NSView {
        cellView.alignment = .center
        if let _ = item as? InspectableTree {
            cellView.stringValue = "💼"
            return cellView
        } else if let _ = item as? InspectableArray {
            cellView.stringValue = "🗄"
            return cellView
        }
        
        let value: InspectableValue
        if let property = item as? InspectableProperty {
            value = property.value
        } else if let itemValue = item as? InspectableValue {
            value = itemValue
        } else {
            fatalError("Invalid outline item")
        }
        
        switch value.value {
        case .number: cellView.stringValue = "🔢"
        case .string: cellView.stringValue = "✉️"
        case .object: cellView.stringValue = "💼"
        case .array: cellView.stringValue = "🗄"
        case .null: cellView.stringValue = "⛔️"
        case .bool: cellView.stringValue = "✅"
        }
        
        return cellView
    }
    
    private func valueView(for cellView: InspectableTextCellView, item: Any) -> NSView {
        cellView.alignment = .left
        
        if let tree = item as? InspectableTree {
            cellView.stringValue = "\(tree.numberOfChildren) Items"
            return cellView
        } else if let array = item as? InspectableArray {
            cellView.stringValue = "\(array.numberOfChildren) Items"
            return cellView
        }
        
        let value: InspectableValue
        if let property = item as? InspectableProperty {
            value = property.value
        } else if let itemValue = item as? InspectableValue {
            value = itemValue
        } else {
            fatalError("Invalid outline item")
        }

        cellView.stringValue = value.displayString
        return cellView
    }
}
