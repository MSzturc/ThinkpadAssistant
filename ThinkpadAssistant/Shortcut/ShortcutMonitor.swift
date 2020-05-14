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
    
    public static let shared = ShortcutMonitor()
    
    private var shortcuts = [EventHotKeyID: Shortcut]()
    private var hotkeys = [Shortcut: [Hotkey]]()
    private var eventHandler: EventHandlerRef
    
    private init() {
        let eventSpec = [
            EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed)),
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
        
        let shortcutNotRegistered = hotkeys[shortcut] == nil
        let hotkey = Hotkey(shortcut, withAction, shortcutNotRegistered)
        
        if shortcutNotRegistered {
            hotkeys[shortcut] = [hotkey]
        } else {
            hotkeys[shortcut]!.append(hotkey)
        }
        shortcuts[hotkey.id] = shortcut
    }
    
    public func unregisterAllShortcuts() {
        hotkeys.removeAll()
        shortcuts.removeAll()
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
        
        let shortcut = shortcuts[hotKeyID]
        if(shortcut == nil){
            return err
        }
        
        let hotkeysForShortcut = hotkeys[shortcut!]
        if(hotkeysForShortcut == nil){
            return err
        }
        
        for hotkey in hotkeysForShortcut! {
            if nsevent.modifierFlags.contains((hotkey.shortcut.modifiers)) {
                hotkey.handler()
            }
        }
        return noErr
    }
    
}

private func keybindEventHandler(_: EventHandlerCallRef?, event: EventRef?, _: UnsafeMutableRawPointer?) -> OSStatus {
    ShortcutMonitor.shared.handleEvent(event)
}
