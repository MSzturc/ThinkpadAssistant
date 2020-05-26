//
//  BluetoothManager.swift
//  ThinkpadAssistant
//
//  Created by Matt on 24.05.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//
import Foundation
import IOBluetooth

final class BluetoothManager {
    
    static func toggleBluetooth() {
        isEnabled() ? disableBluetooth() : enableBluetooth()
    }
    
    static func isEnabled() -> Bool {
        return IOBluetoothPreferenceGetControllerPowerState() == 1
    }
    
    static func disableBluetooth() {
        IOBluetoothPreferenceSetControllerPowerState(0)
    }
    
    static func enableBluetooth() {
        IOBluetoothPreferenceSetControllerPowerState(1)
    }
}
