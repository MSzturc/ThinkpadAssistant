//
//  ShortcutManager.swift
//  ThinkpadAssistant
//
//  Created by Matt on 17.04.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import Cocoa

final class ShortcutManager {
    
    static let screenshotShortcut = Shortcut(key: .f13, modifiers: [])
    static let mirroringMonitorShortcut = Shortcut(key: .f16, modifiers: [])
    static let disableWlanShortcut = Shortcut(key: .f17, modifiers: [])
    static let disableBluetoothShortcut = Shortcut(key: .f17, modifiers: [.leftShift])
    static let systemPrefsShortcut = Shortcut(key: .f18, modifiers: [])
    static let launchpadShortcut = Shortcut(key: .f19, modifiers: [])
    static let micMuteShortcut = Shortcut(key: .f20, modifiers: [])
    static let micMuteShortcutActivate = Shortcut(key: .f20, modifiers: [.leftShift])
    static let micMuteShortcutDeactivate = Shortcut(key: .f20, modifiers: [.rightShift])
    static let backlightOffShortcut = Shortcut(key: .f16, modifiers: [.leftShift])
    static let backlightDimmedShortcut = Shortcut(key: .f16, modifiers: [.rightShift])
    static let backlightBrightShortcut = Shortcut(key: .f19, modifiers: [.leftShift])
    static let fnlockOnShortcut = Shortcut(key: .f18, modifiers: [.leftShift])
    static let fnlockOffShortcut = Shortcut(key: .f18, modifiers: [.rightShift])
    
    static func register() {
        
        ShortcutMonitor.shared.register(systemPrefsShortcut, withAction: {
            startApp(withBundleIdentifier: "com.apple.systempreferences")
        })
        
        ShortcutMonitor.shared.register(disableBluetoothShortcut, withAction: {
            if(BluetoothManager.isEnabled() == true){
                HUD.showImage(Icons.bluetoothOff, status: NSLocalizedString("Bluetooth\ndisabled", comment: ""))
                BluetoothManager.disableBluetooth()
            } else {
                HUD.showImage(Icons.bluetoothOn, status: NSLocalizedString("Bluetooth\nenabled", comment: ""))
                BluetoothManager.enableBluetooth()
            }
        })
        
        ShortcutMonitor.shared.register(launchpadShortcut, withAction: {
            startApp(withBundleIdentifier: "com.apple.launchpad.launcher")
        })
        
        ShortcutMonitor.shared.register(micMuteShortcut, withAction: {
            if(MuteMicManager.isMuted() == true){
                HUD.showImage(Icons.unmute, status: NSLocalizedString("Microphone\nunmuted", comment: ""))
                MuteMicManager.toggleMute()
            } else {
                HUD.showImage(Icons.mute, status: NSLocalizedString("Microphone\nmuted", comment: ""))
                MuteMicManager.toggleMute()
            }
        })
        
        ShortcutMonitor.shared.register(micMuteShortcutActivate, withAction: {
            if(MuteMicManager.isMuted() == true){
                HUD.showImage(Icons.unmute, status: NSLocalizedString("Microphone\nunmuted", comment: ""))
                MuteMicManager.activateMicrophone()
            }
        })
        
        ShortcutMonitor.shared.register(micMuteShortcutDeactivate, withAction: {
            if(MuteMicManager.isMuted() == false){
                HUD.showImage(Icons.mute, status: NSLocalizedString("Microphone\nmuted", comment: ""))
                MuteMicManager.deactivateMicrophone()
            }
        })
        
        ShortcutMonitor.shared.register(disableWlanShortcut, withAction: {
            if(WifiManager.isPowered() == nil){
                return
            } else if(WifiManager.isPowered() == true){
                HUD.showImage(Icons.wlanOff, status: NSLocalizedString("Wi-Fi\ndisabled", comment: ""))
                WifiManager.disableWifi()
            } else {
                HUD.showImage(Icons.wlanOn, status: NSLocalizedString("Wi-Fi\nenabled", comment: ""))
                WifiManager.enableWifi()
            }
        })
        
        ShortcutMonitor.shared.register(mirroringMonitorShortcut, withAction: {
            if(DisplayManager.isDisplayMirrored() == true){
                DispatchQueue.background(background: {
                    DisplayManager.disableHardwareMirroring()
                }, completion:{
                    HUD.showImage(Icons.extending, status: NSLocalizedString("Screen\nextending", comment: ""))
                })
            } else {
                DispatchQueue.background(background: {
                    DisplayManager.enableHardwareMirroring()
                }, completion:{
                    HUD.showImage(Icons.mirroring, status: NSLocalizedString("Screen\nmirroring", comment: ""))
                })
            }
        })
                
        ShortcutMonitor.shared.register(backlightOffShortcut, withAction: {
            HUD.showImage(Icons.backlightOff, status: NSLocalizedString("Backlight\noff", comment: ""))
        })
        
        ShortcutMonitor.shared.register(backlightDimmedShortcut, withAction: {
            HUD.showImage(Icons.backlightDimmed, status: NSLocalizedString("Backlight\ndimmed", comment: ""))
        })
        
        ShortcutMonitor.shared.register(backlightBrightShortcut, withAction: {
            HUD.showImage(Icons.backlightBright, status: NSLocalizedString("Backlight\nbright", comment: ""))
        })
        
        ShortcutMonitor.shared.register(fnlockOnShortcut, withAction: {
            HUD.showImage(Icons.fnlockOn, status: NSLocalizedString("Function\nKeys", comment: ""))
        })
        
        ShortcutMonitor.shared.register(fnlockOffShortcut, withAction: {
            HUD.showImage(Icons.fnlockOff, status: NSLocalizedString("Media\nKeys", comment: ""))
        })
        
        ShortcutMonitor.shared.register(screenshotShortcut, withAction: {
        //startApp(withBundleIdentifier: "com.apple.systempreferences")
            ScreenshotManager.captureScreen()
        })
    }
    
    static func unregister() {
        ShortcutMonitor.shared.unregisterAllShortcuts()
    }
    
    private static func startApp(withBundleIdentifier: String){
        
        let focusedApp = NSWorkspace.shared.frontmostApplication?.bundleIdentifier
        
        if(withBundleIdentifier == focusedApp){
            NSRunningApplication.runningApplications(withBundleIdentifier: focusedApp!).first?.hide()
        } else {
            NSWorkspace.shared.launchApplication(withBundleIdentifier: withBundleIdentifier, options: NSWorkspace.LaunchOptions.default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
        }
    }
}
