//
//  ViewController.swift
//  ThinkpadAssistant
//
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import Cocoa
import ServiceManagement

class SettingsViewController: NSViewController {
    
    let helperBundleName = "de.mszturc.AutoLaunchHelper"

    @IBOutlet weak var autoLaunchCheckbox: NSButton!
    
    @IBOutlet var micView: NSView!
    
    @IBAction func toggleAutoLaunch(_ sender: NSButton) {
        let isAuto = sender.state == .on
        SMLoginItemSetEnabled(helperBundleName as CFString, isAuto)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let foundHelper = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == helperBundleName
        }
        
        autoLaunchCheckbox.state = foundHelper ? .on : .off
    }
}

