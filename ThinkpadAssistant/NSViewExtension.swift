//
//  NSViewExtension.swift
//  ThinkpadAssistant
//
//  Created by Matt on 22.04.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import AppKit

class RoundedEffectView: NSVisualEffectView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cornerRadius: CGFloat = 20 {
        didSet{
            needsDisplay = true
        }
    }
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        blendingMode = .withinWindow
        if #available(OSX 10.14, *) {
            material = .popover
        } else {
            material = .appearanceBased
            wantsLayer = true
        }
        state = .active
    }
    
    override func updateLayer() {
        super.updateLayer()
        layer?.cornerRadius = cornerRadius
    }
}


extension NSView{
    
    func insertVisualEffectView(){
        let vibrant = RoundedEffectView(frame: bounds)
        vibrant.blendingMode = .behindWindow
        vibrant.material = .popover
        vibrant.state = .active
        
        var titlebarHeight: CGFloat {
            return NSWindow.frameRect(forContentRect: CGRect.zero, styleMask: .titled).size.height
        }
        
        let monitor = NSApplication.shared.windows[0]
        let xPos = NSWidth(monitor.screen!.frame)/2 - 200/2
        let yPos = NSHeight(monitor.screen!.frame)/2 - 200/2 - (NSHeight(monitor.screen!.frame) / 5)
        
        vibrant.frame = NSRect(x: xPos, y: yPos, width: 200, height: 200)
        
        addSubview(vibrant, positioned: .below, relativeTo: nil)
    }
    
    
}
