//
//  ScreenshotManager.swift
//  ThinkpadAssistant
//
//  Created by Vojtěch Jungmann on 18/08/2020.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import Foundation
import CoreGraphics
import AppKit

final class ScreenshotManager {
    
    private(set) static var isActive: Bool {
        get {
            UserDefaults.standard.bool(forKey: "ScreenshotMonitoringEnabled")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ScreenshotMonitoringEnabled")
        }
    }

    private(set) static var isSurpressed: Bool {
        get {
            UserDefaults.standard.bool(forKey: "ScreenshotAlertSurpressed")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ScreenshotAlertSurpressed")
        }
    }
    
    static func start() {
        isActive = true
    }

    static func stop() {
        isActive = false
    }
    
    // From https://gist.github.com/soffes/da6ea98be4f56bc7b8e75079a5224b37
    @available(macOS 10.15, *)
    private static func canRecordScreen() -> Bool {
        // Trigger Security&Privacy Window
        CGDisplayCreateImage(CGMainDisplayID())
        let runningApplication = NSRunningApplication.current
        let processIdentifier = runningApplication.processIdentifier

        guard let windows = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID)
            as? [[String: AnyObject]] else
        {
            assertionFailure("Invalid window info")
            return false
        }

        for window in windows {
            // Get information for each window
            guard let windowProcessIdentifier = (window[String(kCGWindowOwnerPID)] as? Int).flatMap(pid_t.init) else {
                assertionFailure("Invalid window info")
                continue
            }

            // Don't check windows owned by this process
            if windowProcessIdentifier == processIdentifier {
                continue
            }

            // Get process information for each window
            guard let windowRunningApplication = NSRunningApplication(processIdentifier: windowProcessIdentifier) else {
                // Ignore processes we don't have access to, such as WindowServer, which manages the windows named
                // "Menubar" and "Backstop Menubar"
                continue
            }

            if window[String(kCGWindowName)] as? String != nil {
                if windowRunningApplication.executableURL?.lastPathComponent == "Dock" {
                    // Ignore the Dock, which provides the desktop picture
                    continue
                } else {
                    return true
                }
            }
        }

        return false
    }
    
    private static func displayInformativeWindow() {
        if isSurpressed != true {
            let alert = NSAlert()
            alert.messageText = NSLocalizedString("Screen Capture Permission is Required", comment: "")
            alert.informativeText = NSLocalizedString("Thinkpad Assistant uses Screen Capture for its screenshot functionality. \n\nWithout the required permissions, you'll only be able to see blank screens on macOS Catalina and later", comment: "")
            alert.alertStyle = .warning
            alert.showsSuppressionButton = true
            alert.addButton(withTitle: "OK")
            alert.runModal()
            if (alert.suppressionButton?.state == NSControl.StateValue.on) {
                isSurpressed = true
            }
        }
    }

    private static func getScreenshotDestination() -> URL {
        
        let desktopPath = (NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true) as [String]).first
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd' 'HH.mm.ss'.jpg'"
        let date = formatter.string(from: Date())
        return URL(fileURLWithPath: desktopPath! + "/" + date)

    }
    
    static func captureScreen() {
        if isActive == true {
        if #available(macOS 10.15 , *) {
            if canRecordScreen() == false {
                displayInformativeWindow()
                return
            }
        }
        let displayId = CGMainDisplayID()
        let image = CGDisplayCreateImage(displayId)
        let dest = CGImageDestinationCreateWithURL(getScreenshotDestination() as CFURL, kUTTypeJPEG, 1, nil)
        CGImageDestinationAddImage(dest!, image!, nil)
        CGImageDestinationFinalize(dest!)
        }

    }
    
}
