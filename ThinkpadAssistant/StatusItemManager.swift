//
//  StatusItemManager.swift
//  ThinkpadAssistant
//
//  Created by Matt on 17.04.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import Cocoa
import Foundation

class StatusItemManager: NSObject, NSMenuDelegate {

    var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
}
