//
//  NSObject+configurable.swift
//  Squaders
//
//  Created by Umur Gedik on 3.10.2021.
//

import Foundation

protocol Configurable { }

extension Configurable {
    func configure(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: Configurable { }
