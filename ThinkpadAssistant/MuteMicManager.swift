//
//  MuteMicManager.swift
//  ThinkpadAssistant
//
//  Created by Matt on 20.04.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import CoreAudio

final class MuteMicManager {
    
    private static let shared = MuteMicManager()
    
    static func toggleMute() {
        shared.toogleMute()
    }
    
    static func isMuted() -> Bool {
        return shared.isMuted()
    }
    
    /// called in background twice!!
    var didChange: ((_ isMuted: Bool) -> Void)?
    
    private var defaultInputDevicePropertyAddress = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDefaultInputDevice,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMaster)
    
    private var mutePropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioDevicePropertyMute,
                                                                 mScope: kAudioDevicePropertyScopeInput,
                                                                 mElement: kAudioObjectPropertyElementMaster)
    
    private let systemInputDeviceID = AudioObjectID(kAudioObjectSystemObject)
    private var currentInputDeviceID = AudioObjectID(kAudioObjectUnknown)
    private var propertySize = UInt32(MemoryLayout<UInt32>.size)
    
    init() {
        setupCurrentInputDeviceID()
        startListener()
    }
    
    deinit {
        stopListener()
    }
    
    private func setupCurrentInputDeviceID() {
        AudioObjectGetPropertyData(systemInputDeviceID, &defaultInputDevicePropertyAddress, 0, nil, &propertySize, &currentInputDeviceID).handleError()
        assert(currentInputDeviceID != kAudioObjectUnknown)
    }
    
    func isMuted() -> Bool {
        var isMuted: DarwinBoolean = false
        AudioObjectGetPropertyData(currentInputDeviceID, &mutePropertyAddress, 0, nil, &propertySize, &isMuted).handleError()
        return isMuted.boolValue
    }
    
    func setMute(_ mute: Bool) {
        var toggleMute: UInt32 = mute ? 1 : 0
        AudioObjectSetPropertyData(currentInputDeviceID, &mutePropertyAddress, 0, nil, propertySize, &toggleMute).handleError()
    }
    
    func toogleMute() {
        assert(isMuteSettable())
        setMute(!isMuted())
    }
    
    private func isMuteSettable() -> Bool {
        var isSettable: DarwinBoolean = false
        AudioObjectIsPropertySettable(currentInputDeviceID, &mutePropertyAddress, &isSettable).handleError()
        return isSettable.boolValue
    }
    
    // MARK: - Listener
    
    private func startListener() {
        /// https://stackoverflow.com/a/33310021/5893286
        let selfPointer = Unmanaged.passUnretained(self).toOpaque()
        
        /// can be used AudioObjectRemovePropertyListenerBlock
        AudioObjectAddPropertyListener(systemInputDeviceID, &defaultInputDevicePropertyAddress, defaultInputDeviceListener, selfPointer).handleError()
        AudioObjectAddPropertyListener(currentInputDeviceID, &mutePropertyAddress, muteListener, selfPointer).handleError()
    }
    
    private func stopListener() {
        let selfPonter = Unmanaged.passUnretained(self).toOpaque()
        AudioObjectRemovePropertyListener(systemInputDeviceID, &defaultInputDevicePropertyAddress, defaultInputDeviceListener, selfPonter).handleError()
        AudioObjectRemovePropertyListener(currentInputDeviceID, &mutePropertyAddress, muteListener, selfPonter).handleError()
    }
    
    /// doesn't called on headphone connection
    private let defaultInputDeviceListener: AudioObjectPropertyListenerProc = { _, _, _, selfPointer in
        selfPointer.assertExecute {
            let audioManager = Unmanaged<MuteMicManager>.fromOpaque($0).takeUnretainedValue()
            audioManager.deviceDidChange()
        }
        return kAudioHardwareNoError
    }
    
    private let muteListener: AudioObjectPropertyListenerProc = { _, _, _, selfPointer in
        selfPointer.assertExecute {
            let audioManager = Unmanaged<MuteMicManager>.fromOpaque($0).takeUnretainedValue()
            audioManager.muteDidChange()
        }
        return kAudioHardwareNoError
    }
    
    private func deviceDidChange() {
        assert(currentInputDeviceID != kAudioObjectUnknown)
        let savedMute = isMuted()
        stopListener()
        
        setupCurrentInputDeviceID()
        
        setMute(savedMute)
        startListener()
        print("-",savedMute)
    }
    
    private func muteDidChange() {
        didChange?(isMuted())
    }
}

extension OSStatus {
    func handleError() {
        assert(self == kAudioHardwareNoError, "reason: \(self)")
    }
}

extension Optional {
    func assert(or defaultValue: Wrapped) -> Wrapped {
        switch self {
        case .none:
            assertionFailure()
            return defaultValue
        case .some(let value):
            return value
        }
    }
    
    func assertExecute(_ action: (Wrapped) throws -> Void) rethrows {
        switch self {
        case .none:
            assertionFailure()
        case .some(let value):
            try action(value)
        }
    }
}
