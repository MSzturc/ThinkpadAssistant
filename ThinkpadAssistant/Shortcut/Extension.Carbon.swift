//
//  Extension.Carbon.swift
//  ThinkpadAssistant
//
//  Created by Matt on 10.05.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import Foundation
import Carbon
import Cocoa

extension EventHotKeyID: Equatable, Hashable
{
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(signature)
        hasher.combine(id)
    }
    
    public static func ==(lhs: EventHotKeyID, rhs: EventHotKeyID) -> Bool {
        return lhs.signature == rhs.signature && lhs.id == rhs.id
    }
}

extension NSEvent.ModifierFlags : Hashable
{
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }
}

extension NSInteger {
    public var carbonKeyCode: UInt32 {
        var carbonKeyCode: UInt32 = 0
        if self != NSNotFound {
            carbonKeyCode = UInt32(self)
        }
        return carbonKeyCode
    }
}

extension NSEvent.ModifierFlags {

  static let rightShift   = NSEvent.ModifierFlags(rawValue: 0x020004)
  static let leftShift    = NSEvent.ModifierFlags(rawValue: 0x020002)
  static let rightCommand = NSEvent.ModifierFlags(rawValue: 0x100010)
  static let leftCommand  = NSEvent.ModifierFlags(rawValue: 0x100008)
  static let rightOption  = NSEvent.ModifierFlags(rawValue: 0x080040)
  static let leftOption   = NSEvent.ModifierFlags(rawValue: 0x080020)
  static let rightControl = NSEvent.ModifierFlags(rawValue: 0x042000)
  static let leftControl  = NSEvent.ModifierFlags(rawValue: 0x040001)

}

extension NSEvent.ModifierFlags {
    public var carbonFlags: UInt32 {
        var carbonFlags: UInt32 = 0

        if contains(.command) {
            carbonFlags |= UInt32(cmdKey)
        }

        if contains(.option) {
            carbonFlags |= UInt32(optionKey)
        }

        if contains(.control) {
            carbonFlags |= UInt32(controlKey)
        }

        if contains(.shift) {
            carbonFlags |= UInt32(shiftKey)
        }

        return carbonFlags
    }

    public init(carbonFlags: UInt32) {
        self.init()

        if carbonFlags & UInt32(cmdKey) == UInt32(cmdKey) {
            insert(.command)
        }

        if carbonFlags & UInt32(optionKey) == UInt32(optionKey) {
            insert(.option)
        }

        if carbonFlags & UInt32(controlKey) == UInt32(controlKey) {
            insert(.control)
        }

        if carbonFlags & UInt32(shiftKey) == UInt32(shiftKey) {
            insert(.shift)
        }
    }
}
