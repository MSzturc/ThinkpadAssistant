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
    
    private static var isRunning: Bool = false
    
    static func disableWifi() {
        toggleMasterSwitch(false)
    }
    
    static func enableWifi() {
        toggleMasterSwitch(true)
    }
    
    static func isPowered() -> Bool? {
        if(isRunning){
            return nil
        }
        return CWWiFiClient.shared().interface()?.powerOn() ?? false
    }
    
    private static func toggleMasterSwitch(_ status:Bool) {
        if(isRunning){
            return
        }
        isRunning = true
        DispatchQueue.background(background: {
            do {
                try CWWiFiClient.shared().interface()?.setPower(status)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }, completion:{
            isRunning = false
        })
    }
}

extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }

}
