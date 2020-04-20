//
//  ShortcutManager.swift
//  ThinkpadAssistant
//
//  Created by Matt on 17.04.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import Foundation
import MASShortcut

class ShortcutManager {
    
    static let mirroringMonitorShortcut = MASShortcut(keyCode: kVK_F16, modifierFlags: [])
    static let disableWlanShortcut = MASShortcut(keyCode: kVK_F17, modifierFlags: [])
    static let systemPrefsShortcut = MASShortcut(keyCode: kVK_F18, modifierFlags: [])
    static let launchpadShortcut = MASShortcut(keyCode: kVK_F19, modifierFlags: [])
    static let micMuteShortcut = MASShortcut(keyCode: kVK_F20, modifierFlags: [])
    
    private static var muteIcon:NSImage = {
        let image = NSImage(named: "NSTouchBarAudioInputMuteTemplate")
        let resized = image!.resizeWhileMaintainingAspectRatioToSize(size: NSSize(width: 76.0, height: 120.0))
        let cropped = resized!.crop(size: NSSize(width: 85.0, height: 130.0))
        cropped?.isTemplate = true
        return cropped!
    }()
    
    private static var unmuteIcon:NSImage = {
        let image = NSImage(named: "NSTouchBarAudioInputTemplate")
        let resized = image!.resizeWhileMaintainingAspectRatioToSize(size: NSSize(width: 36.0, height: 120.0))
        let cropped = resized!.crop(size: NSSize(width: 40.3, height: 130.0))
        cropped?.isTemplate = true
        return cropped!
    }()
    
    private static var wlanOnIcon:NSImage = {
        let wlanIcon = NSImage(named: NSImage.Name("wlanOn"))
        wlanIcon?.isTemplate = true
        return wlanIcon!
    }()
    
    private static var wlanOffIcon:NSImage = {
        let wlanIcon = NSImage(named: NSImage.Name("wlanOff"))
        wlanIcon?.isTemplate = true
        return wlanIcon!
    }()
    
    private static var screenMirroringIcon:NSImage = {
        let mirroringIcon = NSImage(named: NSImage.Name("mirroring"))
        mirroringIcon?.isTemplate = true
        return mirroringIcon!
    }()
    
    private static var screenExtendingIcon:NSImage = {
        let mirroringIcon = NSImage(named: NSImage.Name("extending"))
        mirroringIcon?.isTemplate = true
        return mirroringIcon!
    }()

    class func register() {
        MASShortcutMonitor.shared()?.register(systemPrefsShortcut, withAction: {
            startApp(withBundleIdentifier: "com.apple.systempreferences")
            })
        
        MASShortcutMonitor.shared()?.register(launchpadShortcut, withAction: {
            startApp(withBundleIdentifier: "com.apple.launchpad.launcher")
        })
        
        MASShortcutMonitor.shared()?.register(micMuteShortcut, withAction: {
            if(MuteMicManager.shared.isMuted() == true){
                HUD.showImage(unmuteIcon, status: "Microphone              \nunmuted")
                MuteMicManager.shared.toogleMute()
                
            } else {
                HUD.showImage(muteIcon, status: "Microphone              \nmuted")
                MuteMicManager.shared.toogleMute()
                
            }
        })
        
        MASShortcutMonitor.shared()?.register(disableWlanShortcut, withAction: {
            if(WifiManager.shared.isPowered == true){
                HUD.showImage(wlanOffIcon, status: "Wi-Fi                        \ndisabled")
                MuteMicManager.shared.toogleMute()
                WifiManager.shared.toggleMasterSwitch(status: false)
                
            } else {
                HUD.showImage(wlanOnIcon, status: "Wi-Fi                        \nenabled")
                WifiManager.shared.toggleMasterSwitch(status: true)
                
            }
        })
        
        MASShortcutMonitor.shared()?.register(mirroringMonitorShortcut, withAction: {
            if(DisplayManager.getDisplayCount() > 1){
                if(DisplayManager.isDisplayedMirrored() == true){
                    HUD.showImage(screenExtendingIcon, status: "Screen                        \nextending")
                    DisplayManager.toggleMirroring()
                    
                } else {
                    HUD.showImage(screenMirroringIcon, status: "Screen                        \nmirroring")
                    DisplayManager.toggleMirroring()
                }
            }
        })
        
    }
    
    
    class func unregister() {
        MASShortcutMonitor.shared().unregisterShortcut(systemPrefsShortcut)
    }
    
    class func startApp(withBundleIdentifier: String){
        
        let focusedApp = NSWorkspace.shared.frontmostApplication?.bundleIdentifier
        
        if(withBundleIdentifier == focusedApp){
            NSRunningApplication.runningApplications(withBundleIdentifier: focusedApp!).first?.hide()
        } else {
            NSWorkspace.shared.launchApplication(withBundleIdentifier: withBundleIdentifier, options: NSWorkspace.LaunchOptions.default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
        }
    }
}
