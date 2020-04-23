//
//  WifiManager.swift
//  ThinkpadAssistant
//
//  Created by Matt on 20.04.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//
import Foundation
import CoreWLAN

final class WifiManager {
    
    static func toggleWifi() {
        isPowered() ? disableWifi() : enableWifi()
    }
    
    static func disableWifi() {
        toggleMasterSwitch(false)
        
    }
    
    static func enableWifi() {
        toggleMasterSwitch(true)
    }
    
    static func isPowered() -> Bool {
        return CWWiFiClient.shared().interface()?.powerOn() ?? false
    }
    
    private static func toggleMasterSwitch(_ status:Bool) {
        do {
            try CWWiFiClient.shared().interface()?.setPower(status)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
