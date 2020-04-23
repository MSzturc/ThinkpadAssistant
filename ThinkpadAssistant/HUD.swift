//
//  HUD.swift
//  ThinkpadAssistant
//
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import AppKit

typealias ProgressHUDDismissCompletion = () -> Void

class HUD: NSView {
    
    static let shared = HUD()
    
    private override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        // setup view
        autoresizingMask = [.maxXMargin, .minXMargin, .maxYMargin, .minYMargin]
        alphaValue = 0.0
        isHidden = true
        
        // setup status message label
        statusLabel.isEditable = false
        statusLabel.isSelectable = false
        statusLabel.alignment = .center
        statusLabel.backgroundColor = .clear
        statusLabel.textColor = NSColor.secondaryLabelColor
        statusLabel.font = NSFont.systemFont(ofSize: 20)
        addSubview(statusLabel)
        
        // setup window into which to display the HUD
        let screen = NSScreen.screens[0]
        let window = NSWindow(contentRect: screen.frame, styleMask: .borderless, backing: .buffered, defer: true, screen: screen)
        window.level = .floating
        window.backgroundColor = .clear
        windowController = NSWindowController(window: window)
        
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Presents a HUD with an image + status, and dismisses the HUD a little bit later
    class func showImage(_ image: NSImage, status: String) {
        let imageView = NSImageView(frame: NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        imageView.image = image
        HUD.shared.show(withStatus: status, imageView: imageView)
        HUD.dismiss(delay: 1.5)
    }
    
    /// Dismisses the currently visible `ProgressHUD` if visible, after a time interval
    class func dismiss(delay: TimeInterval) {
        HUD.shared.perform(#selector(hideDelayed), with: 1, afterDelay: delay)
    }
    
    private var image: NSView?
    private var size: CGSize = .zero
    private let statusLabel = NSText(frame: .zero)
    private var windowController: NSWindowController?
    
    private var hudView: NSView? {
        windowController?.showWindow(self)
        windowController?.window?.contentView?.insertVisualEffectView()
        return windowController?.window?.contentView
    }
    
    private func show(withStatus status: String, imageView: NSView) {
        guard let view = hudView else { return }
        
        if isHidden {
            frame = view.frame
            view.addSubview(self)
        } else {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
        }
        setupImage(view: imageView)
        setStatus(status)
        show()
    }
    
    private func show() {
        needsDisplay = true
        isHidden = false
        
        // Fade in
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0.20
        animator().alphaValue = 1.0
        window?.animator().alphaValue = 1.0
        NSAnimationContext.endGrouping()
        
    }
    
    private func hide() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        // Fade out
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0.20
        NSAnimationContext.current.completionHandler = {
            self.done()
        }
        animator().alphaValue = 0
        window?.animator().alphaValue = 0
        
        NSAnimationContext.endGrouping()
        
    }
    
    private func done() {
        alphaValue = 0.0
        window?.alphaValue = 0.0
        isHidden = true
        removeFromSuperview()
        image?.removeFromSuperview()
        image = nil
        statusLabel.string = ""
        windowController?.close()
    }
    
    private func setStatus(_ status: String) {
        statusLabel.string = status
        statusLabel.sizeToFit()
    }
    
    private func setupImage(view: NSView) {
        image?.removeFromSuperview()
        image = view
        addSubview(image!)
    }
    
    @objc private func hideDelayed() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        hide()
    }
    
    // MARK: - Layout & Drawing
    
    override func draw(_ rect: NSRect) {
        // Entirely cover the parent view
        frame = superview?.bounds ?? .zero
        
        // Determine the total width and height needed
        let maxWidth = bounds.size.width - 64
        var totalSize = CGSize.zero
        var imageFrame = image?.bounds ?? .zero
        
        imageFrame.size.width = min(imageFrame.size.width, maxWidth)
        totalSize.width = max(totalSize.width, imageFrame.size.width)
        totalSize.height += imageFrame.size.height
        
        var statusLabelSize: CGSize = statusLabel.string.count > 0 ? statusLabel.string.size(withAttributes: [NSAttributedString.Key.font: statusLabel.font!]) : CGSize.zero
        if statusLabelSize.width > 0.0 {
            statusLabelSize.width += 10.0
        }
        statusLabelSize.width = min(statusLabelSize.width, maxWidth)
        totalSize.width = max(totalSize.width, statusLabelSize.width)
        totalSize.height += statusLabelSize.height
        
        totalSize.width += 32
        totalSize.height += 32
        
        // Position elements
        var yPos = round((bounds.size.height - totalSize.height) / 2) + 16 - (bounds.size.height / 5)
        
        if statusLabelSize.height > 0.0 && imageFrame.size.height > 0.0 {
            yPos += statusLabelSize.height
        }
        let xPos: CGFloat = 0
        imageFrame.origin.y = yPos
        imageFrame.origin.x = round((bounds.size.width - imageFrame.size.width) / 2) + xPos
        image?.frame = imageFrame
        
        if statusLabelSize.height > 0.0 && imageFrame.size.height > 0.0 {
            yPos -= statusLabelSize.height
        }
        var statusLabelFrame = CGRect.zero
        statusLabelFrame.origin.y = yPos
        statusLabelFrame.origin.x = round((bounds.size.width - statusLabelSize.width) / 2) + xPos
        statusLabelFrame.size = statusLabelSize
        statusLabel.frame = statusLabelFrame
        
        size = totalSize
    }
    
}

class RoundedEffectView: NSVisualEffectView {
    
    var cornerRadius: CGFloat = 20 {
        didSet{
            needsDisplay = true
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        blendingMode = .behindWindow
        material = .popover
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
        
        let monitor = NSApplication.shared.windows[0]
        let xPos = NSWidth(monitor.screen!.frame)/2 - 100
        let yPos = NSHeight(monitor.screen!.frame)/2 - 100 - (NSHeight(monitor.screen!.frame) / 5)
        
        vibrant.frame = NSRect(x: xPos, y: yPos, width: 200, height: 200)
        
        addSubview(vibrant, positioned: .below, relativeTo: nil)
    }
}
