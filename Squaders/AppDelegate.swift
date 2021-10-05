//
//  AppDelegate.swift
//  Squaders
//
//  Created by Umur Gedik on 3.10.2021.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var appState: AppState!
    weak var browserWindow: BrowserWindow?
    
    func showBrowserWindow() {
        if let window = browserWindow {
            window.makeKeyAndOrderFront(self)
            return
        }
        
        browserWindow = BrowserWindow.make(appState: appState)
        browserWindow?.makeKeyAndOrderFront(self)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        appState = AppState(httpService: HTTPService())
        showBrowserWindow()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

