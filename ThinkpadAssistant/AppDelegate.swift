//
//  AppDelegate.swift
//  ThinkpadAssistant
//
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import Cocoa
import MASShortcut

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

    @IBOutlet weak var statusBarMenu: NSMenu!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupMenuBar()
        //Register global Hotkeys
        ShortcutManager.register()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        ShortcutManager.unregister()
    }
    
    func setupMenuBar() {
        statusItem.button?.title = "T"
        statusItem.menu = statusBarMenu
    }
    
    @IBAction func quitPressed(_ sender: Any) {
        NSApp.terminate(self)
    }
    
}

