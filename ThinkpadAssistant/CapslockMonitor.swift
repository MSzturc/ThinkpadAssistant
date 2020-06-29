//
//  CapslockMonitor.swift
//  ThinkpadAssistant
//
//  Created by Igor Kulman on 22/06/2020.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import Cocoa
import Foundation

final class CapslockMonitor {
    private static  var lastState: Bool? = nil
    private(set) static var isActive: Bool {
        get {
            UserDefaults.standard.bool(forKey: "CapslockMonitoringEnabled")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "CapslockMonitoringEnabled")
        }
    }

    static func register() {
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged, handler: flagsChanged)
    }

    static func start() {
        isActive = true
    }

    static func stop() {
        isActive = false
    }

    private static func flagsChanged(with event: NSEvent) {
        let isEnabled = event.modifierFlags.intersection(.deviceIndependentFlagsMask).contains(.capsLock)
        guard isActive else {
            lastState = isEnabled
            return
        }

        if isEnabled != lastState {
            if isEnabled {
                HUD.showImage(Icons.capslockOn, status: NSLocalizedString("Capslock\nenabled", comment: ""))
            } else {
                HUD.showImage(Icons.capslockOff, status: NSLocalizedString("Capslock\ndisabled", comment: ""))
            }
        }
        lastState = isEnabled
    }
}
