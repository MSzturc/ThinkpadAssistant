//
//  ShortcutManager.swift
//  ThinkpadAssistant
//
//  Created by Matt on 17.04.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import Foundation
import MASShortcut

final class ShortcutManager {
    
    static let mirroringMonitorShortcut = MASShortcut(keyCode: kVK_F16, modifierFlags: [])
    static let disableWlanShortcut = MASShortcut(keyCode: kVK_F17, modifierFlags: [])
    static let systemPrefsShortcut = MASShortcut(keyCode: kVK_F18, modifierFlags: [])
    static let launchpadShortcut = MASShortcut(keyCode: kVK_F19, modifierFlags: [])
    static let micMuteShortcut = MASShortcut(keyCode: kVK_F20, modifierFlags: [])
    
    static func register() {
        MASShortcutMonitor.shared()?.register(systemPrefsShortcut, withAction: {
            startApp(withBundleIdentifier: "com.apple.systempreferences")
        })
        
        MASShortcutMonitor.shared()?.register(launchpadShortcut, withAction: {
            startApp(withBundleIdentifier: "com.apple.launchpad.launcher")
        })
        
        MASShortcutMonitor.shared()?.register(micMuteShortcut, withAction: {
            if(MuteMicManager.isMuted() == true){
                HUD.showImage(Icons.unmute, status: "Microphone\nunmuted")
                MuteMicManager.toggleMute()
            } else {
                HUD.showImage(Icons.mute, status: "Microphone\nmuted")
                MuteMicManager.toggleMute()
            }
        })
        
        MASShortcutMonitor.shared()?.register(disableWlanShortcut, withAction: {
            if(WifiManager.isPowered() == nil){
                return
            } else if(WifiManager.isPowered() == true){
                HUD.showImage(Icons.wlanOff, status: "Wi-Fi\ndisabled")
                WifiManager.disableWifi()
            } else {
                HUD.showImage(Icons.wlanOn, status: "Wi-Fi\nenabled")
                WifiManager.enableWifi()
            }
        })
        
        MASShortcutMonitor.shared()?.register(mirroringMonitorShortcut, withAction: {
            if(DisplayManager.getDisplayCount() > 1){
                if(DisplayManager.isDisplayMirrored() == true){
                    DispatchQueue.background(background: {
                        DisplayManager.disableHardwareMirroring()
                    }, completion:{
                        HUD.showImage(Icons.extending, status: "Screen\nextending")
                    })
                } else {
                    DispatchQueue.background(background: {
                        DisplayManager.enableHardwareMirroring()
                    }, completion:{
                        HUD.showImage(Icons.mirroring, status: "Screen\nmirroring")
                    })
                }
            }
        })
        
    }
    
    static func unregister() {
        MASShortcutMonitor.shared().unregisterShortcut(systemPrefsShortcut)
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
