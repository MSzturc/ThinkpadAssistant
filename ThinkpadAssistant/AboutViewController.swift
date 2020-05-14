//
//  AboutViewController.swift
//  ThinkpadAssistant
//
//  Created by Matt on 14.05.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import Foundation
import Cocoa

class AboutViewController: NSViewController {
    
    @IBOutlet weak var versionLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionLabel.stringValue = NSLocalizedString("Version", comment: "") + " " + version
        }
        NSApp.activate(ignoringOtherApps: true)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: NSApplication.willResignActiveNotification, object: nil)
        
    }
    
    @objc func appMovedToBackground() {
        self.view.window!.close()
    }
    
}
