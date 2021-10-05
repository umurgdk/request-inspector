//
//  Inspectable.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import Foundation

protocol Inspectable {
    var inspectableTree: InspectableTree { get }
}

class InspectableValue {
    let value: Value
    init(_ value: Value) {
        self.value = value
    }
    
    enum Value {
        case number(Float)
        case string(String)
        case bool(Bool)
        case null
        case array(InspectableArray)
        case object(InspectableTree)
    }
        
    var displayString: String {
        switch value {
        case .number(let number):
            if number == floor(number) {
                return String(Int(number))
            } else {
                return String(number)
            }
            
        case .string(let string): return string
        case .bool(let bool): return String(bool)
        case .null: return "null"
        case .array(let tree): return "\(tree.numberOfChildren) Items"
        case .object(let tree): return "\(tree.numberOfChildren) Items"
        }
    }
}

class InspectableProperty {
    let name: String
    let value: InspectableValue
    init(name: String, value: InspectableValue) {
        self.name = name
        self.value = value
    }
}

class InspectableArray {
    let children: [InspectableValue]
    init(children: [InspectableValue]) {
        self.children = children
    }
    
    var hasChildren: Bool { !children.isEmpty }
    var numberOfChildren: Int { children.count }
}

class InspectableTree {
    let name: String
    let children: [InspectableProperty]
    
    var hasChildren: Bool { !children.isEmpty }
    var numberOfChildren: Int { children.count }
    
    init(name: String, children: [String: InspectableValue.Value]) {
        self.name = name
        self.children = children.map { key, value in InspectableProperty(name: key, value: InspectableValue(value)) }
    }
}
