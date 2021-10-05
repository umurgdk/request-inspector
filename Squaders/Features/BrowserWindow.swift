//
//  BrowserWindow.swift
//  Squaders
//
//  Created by Umur Gedik on 4.10.2021.
//

import AppKit

fileprivate extension NSToolbarItem.Identifier {
    static let makeRequest: Self = .init("BrowserToolbar.makeRequest")
}

class BrowserWindow: NSWindow, NSToolbarDelegate {
    private var appState: AppState!
    static func make(appState: AppState) -> BrowserWindow {
        let viewController = BrowserViewController(appState: appState)
        
        let window = BrowserWindow(contentViewController: viewController)
        window.appState = appState
        
        if #available(macOS 11, *) {
            window.styleMask.insert(.fullSizeContentView)
        }
        
        window.toolbar = NSToolbar(identifier: .init("BrowserToolbar")).configure {
            $0.delegate = window
            $0.displayMode = .iconOnly
        }
        
        window.minSize = CGSize(width: 800, height: 400)
        window.title = "Squaders"
        window.setFrame(CGRect(origin: .zero, size: window.minSize), display: false)
        window.center()
        return window
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [.flexibleSpace, .makeRequest]
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [.flexibleSpace, .makeRequest]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        guard itemIdentifier == .makeRequest else { return nil }
        
        let item = NSToolbarItem(itemIdentifier: .makeRequest)
        item.image = NSImage(named: NSImage.addTemplateName)!
        item.label = "Make Request"
        item.paletteLabel = "Make Request"
        item.target = self
        item.action = #selector(didClickMakeRequest(_:))
        return item
    }
    
    @objc private func didClickMakeRequest(_ sender: NSToolbarItem) {
        appState.makeRequest()
    }
}
