//
//  WifiManager.swift
//  ThinkpadAssistant
//
//  Created by Matt on 20.04.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//
import Foundation
import CoreWLAN

class WifiManager {
    
    static let shared = WifiManager()

    let currentInterface = CWWiFiClient.shared().interface()
    
    var isPowered:Bool{
        get{
            if let isInterface = currentInterface {
                return isInterface.powerOn()
            }
            return false
        }
    }
    
    
    func toggleMasterSwitch(status:Bool) {
        do {
            try currentInterface?.setPower(status)
        } catch let error as NSError {
            print(error.localizedDescription)
            
        }
        catch {
            print("Something went wrong, are you feeling OK?")
            
        };
    }

}
