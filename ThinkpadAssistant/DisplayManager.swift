//
//  DisplayManager.swift
//  ThinkpadAssistant
//
//  Created by Matt on 20.04.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//
import Foundation

final class DisplayManager {
    
    /// https://stackoverflow.com/a/41585973/5893286
    static func toggleMirroring() {
        isDisplayedMirrored() ? disableHardwareMirroring() : enableHardwareMirroring()
    }
    
    // determine if mirroring is active (only relevant for software mirroring)
    // hack to convert from boolean_t (aka UInt32) to swift's bool
    static func isDisplayedMirrored() -> Bool {
        return CGDisplayIsInMirrorSet(CGMainDisplayID()) > 0
    }
    
    /// designed for hardware mirroring with > 1 display
    /// should be no penalty for running with only 1 display, using either hardware or software mirroring drivers
    /// but not tested
    /// https://stackoverflow.com/a/41585973/5893286
    static func disableHardwareMirroring() {
        configureDisplay { displayConfig in
            // only interested in the main display
            // kCGNullDirectDisplay parameter disables hardware mirroring
            CGConfigureDisplayMirrorOfDisplay(displayConfig, CGMainDisplayID(), kCGNullDirectDisplay).handleError()
        }
    }
    
    static func enableHardwareMirroring() {
        let displayCount = getDisplayCount()
        if(displayCount > 1){
            //assert(isDisplayedMirrored() == false)
            
            let mainDisplayId = CGMainDisplayID()
            
            configureDisplay { displayConfig in
                displayIds(for: displayCount)
                    .filter { $0 != mainDisplayId }
                    .forEach { CGConfigureDisplayMirrorOfDisplay(displayConfig, $0, mainDisplayId).handleError() }
            }
        }
    }
    
    static func configureDisplay(handler: (_ displayConfig: CGDisplayConfigRef?) -> Void) {
        //let config = UnsafeMutablePointer<CGDisplayConfigRef?>.allocate(capacity: 1)
        //config.pointee
        var displayConfig: CGDisplayConfigRef?
        CGBeginDisplayConfiguration(&displayConfig).handleError()
        assert(displayConfig != nil)
        handler(displayConfig)
        
        // The first entry in the list of active displays is the main display. In case of mirroring, the first entry is the largest drawable display or, if all are the same size, the display with the greatest pixel depth.
        // The "Permanently" option might not survive reboot when run from playground, but does when run in an application
        // may not be permanent between boots using Playgroud, but is in an application
        if CGCompleteDisplayConfiguration(displayConfig, .permanently).require() != .success {
            CGCancelDisplayConfiguration(displayConfig)
        }
    }
    
    static func getDisplayCount() -> UInt32 {
        var displayCount: UInt32 = 0
        CGGetActiveDisplayList(0, nil, &displayCount).handleError()
        return displayCount
    }
    
    private static func displayIds(for displayCount: UInt32) -> [CGDirectDisplayID] {
        /// https://stackoverflow.com/a/41585973/5893286
        let allocatedDisplayCount = Int(displayCount)
        var displaysIds = Array<CGDirectDisplayID>(repeating: kCGNullDirectDisplay, count: allocatedDisplayCount)
        CGGetActiveDisplayList(displayCount, &displaysIds, nil).handleError()
        return displaysIds
    }
}
