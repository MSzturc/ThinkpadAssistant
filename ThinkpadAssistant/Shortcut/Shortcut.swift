//
//  Keybind.swift
//  ThinkpadAssistant
//
//  Created by Matt on 10.05.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//
import Cocoa

public struct Shortcut: Equatable, Hashable {
    
    public let key: Key
    public let modifiers: NSEvent.ModifierFlags
    
    public var carbonKeyCode: UInt32 {
        get {
            return key.carbonKeyCode
        }
    }
    
    public var carbonModifiers: UInt32 {
        get {
            return modifiers.carbonFlags
        }
    }
    
    public init(key: Key, modifiers: NSEvent.ModifierFlags) {
        self.key = key
        self.modifiers = modifiers
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(carbonModifiers)
        hasher.combine(carbonKeyCode)
    }
    
    static public func == (left: Shortcut, right: Shortcut) -> Bool {
        return left.carbonModifiers == right.carbonModifiers &&
                left.carbonKeyCode == right.carbonKeyCode
    }

}
