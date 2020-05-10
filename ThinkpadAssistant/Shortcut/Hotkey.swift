//
//  Hotkey.swift
//  ThinkpadAssistant
//
//  Created by Matt on 10.05.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//
import Carbon.HIToolbox.Events
import Cocoa

public class Hotkey: Equatable {
    
    public typealias Handler = () -> Void
    
    private static var count: UInt32 = 0
    private static let signature = UTGetOSTypeFromString("TPAS" as CFString)
    
    public let shortcut: Shortcut
    public let handler: Handler
    public let id: EventHotKeyID
    private var hotKeyRef: EventHotKeyRef
    
    public init(_ shortcut: Shortcut, _ handler: @escaping Handler) {
        self.shortcut = shortcut
        self.handler = handler
        Hotkey.count += 1
        self.id = EventHotKeyID(signature: Hotkey.signature, id: Hotkey.count)
        
        var eventHotKeyRef: EventHotKeyRef?
        
        let registerErr = RegisterEventHotKey(
            shortcut.carbonKeyCode,
            shortcut.carbonModifiers,
            id,
            GetEventDispatcherTarget(),
            0,
            &eventHotKeyRef
        )

        assert(registerErr == noErr)
        assert(eventHotKeyRef != nil)
        
        self.hotKeyRef = eventHotKeyRef!
    }
    
    deinit {
        UnregisterEventHotKey(hotKeyRef)
    }
    
    static public func == (left: Hotkey, right: Hotkey) -> Bool {
        return left.id.id == right.id.id &&
            left.id.signature == right.id.signature
    }

}
