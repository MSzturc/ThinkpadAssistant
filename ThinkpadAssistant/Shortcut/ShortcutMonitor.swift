//
//  KeybindController.swift
//  ThinkpadAssistant
//
//  Created by Matt on 10.05.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import Carbon
import Cocoa

public class ShortcutMonitor {
    
    public static var shared: ShortcutMonitor = {
        return ShortcutMonitor()
    }()

    private var hotkeys = [EventHotKeyID: Hotkey]()
    private var eventHandler: EventHandlerRef
    
    init() {
        let eventSpec = [
            EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyReleased)),
        ]

        var eventHandler: EventHandlerRef?
        let installErr = InstallEventHandler(GetEventDispatcherTarget(), keybindEventHandler, 1, eventSpec, nil, &eventHandler)
        
        assert(installErr == noErr)
        assert(eventHandler != nil)
        
        self.eventHandler = eventHandler!
    }
    
    deinit {
        RemoveEventHandler(eventHandler)
    }
    
    public func register(_ shortcut: Shortcut, withAction: @escaping Hotkey.Handler) {
        let hotkey = Hotkey(shortcut, withAction)
        hotkeys[hotkey.id] = hotkey
    }
    
    public func unregisterAllShortcuts() {
        hotkeys.removeAll()
    }

    func handleEvent(_ event: EventRef?) -> OSStatus {
        
        guard let event = event else {
            return OSStatus(eventNotHandledErr)
        }
        
        guard let nsevent = NSEvent(eventRef: UnsafeRawPointer(event)) else {
            return OSStatus(eventNotHandledErr)
        }
        
        var hotKeyID = EventHotKeyID()

        let err = GetEventParameter(
            event,
            UInt32(kEventParamDirectObject),
            UInt32(typeEventHotKeyID),
            nil,
            MemoryLayout<EventHotKeyID>.size,
            nil,
            &hotKeyID
        )

        if err != noErr {
            return err
        }
        
        let hotkey = hotkeys[hotKeyID]
        
        if hotkey != nil {
            if nsevent.modifierFlags.contains((hotkey?.shortcut.modifiers)!) {
                hotkey!.handler()
            }
        } else {
            return err
        }
        return noErr
    }
    
}

private func keybindEventHandler(_: EventHandlerCallRef?, event: EventRef?, _: UnsafeMutableRawPointer?) -> OSStatus {
    ShortcutMonitor.shared.handleEvent(event)
}
