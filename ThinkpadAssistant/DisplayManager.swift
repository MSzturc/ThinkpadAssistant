//
//  DisplayManager.swift
//  ThinkpadAssistant
//
//  Created by Matt on 20.04.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//
import Foundation

final class DisplayManager {
    
    static func toggleMirroring() {
        isDisplayMirrored() ? disableHardwareMirroring() : enableHardwareMirroring()
    }
    
    static func isDisplayMirrored() -> Bool {
        return CGDisplayIsInMirrorSet(CGMainDisplayID()) > 0
    }
    
    static func disableHardwareMirroring() {
        configureDisplay { displayConfig in
            CGConfigureDisplayMirrorOfDisplay(displayConfig, CGMainDisplayID(), kCGNullDirectDisplay).handleError()
        }
    }
    
    static func enableHardwareMirroring() {
        let displayCount = getDisplayCount()
        if(displayCount > 1){
            
            let mainDisplayId = CGMainDisplayID()
            
            configureDisplay { displayConfig in
                displayIds(for: displayCount)
                    .filter { $0 != mainDisplayId }
                    .forEach { CGConfigureDisplayMirrorOfDisplay(displayConfig, $0, mainDisplayId).handleError() }
            }
        }
    }
    
    static func getDisplayCount() -> UInt32 {
        var displayCount: UInt32 = 0
        CGGetActiveDisplayList(0, nil, &displayCount).handleError()
        return displayCount
    }
    
    private static func configureDisplay(handler: (_ displayConfig: CGDisplayConfigRef?) -> Void) {
        
        var displayConfig: CGDisplayConfigRef?
        CGBeginDisplayConfiguration(&displayConfig).handleError()
        assert(displayConfig != nil)
        handler(displayConfig)
        
        if CGCompleteDisplayConfiguration(displayConfig, .permanently).require() != .success {
            CGCancelDisplayConfiguration(displayConfig)
        }
    }
    
    private static func displayIds(for displayCount: UInt32) -> [CGDirectDisplayID] {
        let allocatedDisplayCount = Int(displayCount)
        var displaysIds = Array<CGDirectDisplayID>(repeating: kCGNullDirectDisplay, count: allocatedDisplayCount)
        CGGetActiveDisplayList(displayCount, &displaysIds, nil).handleError()
        return displaysIds
    }
}

extension CGError {
    
    func require() -> CGError {
        assert(self == .success, "reason: \(self)")
        return self
    }
    
    func handleError() {
        assert(self == .success, "reason: \(self)")
    }
}
