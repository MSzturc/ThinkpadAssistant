//
//  IconProvider.swift
//  ThinkpadAssistant
//
//  Created by Matt on 23.04.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import Cocoa

final class Icons {
    
    static let mute = load(iconName: "micOff")
    static let unmute = load(iconName: "micOn")
    static let wlanOn = load(iconName: "wlanOn")
    static let wlanOff = load(iconName: "wlanOff")
    static let mirroring = load(iconName: "mirroring")
    static let extending = load(iconName: "extending")
    static let bluetoothOn = load(iconName: "bluetoothOn")
    static let bluetoothOff = load(iconName: "bluetoothOff")
    static let backlightOff = load(iconName: "backlightOff")
    static let backlightDimmed = load(iconName: "backlightDimmed")
    static let backlightBright = load(iconName: "backlightBright")
    
    private static func load(iconName: String) -> NSImage {
        let icon = NSImage(named: NSImage.Name(iconName))
        icon?.size = NSSize(width: 128, height: 128)
        icon?.isTemplate = true
        return icon!
    }
}


