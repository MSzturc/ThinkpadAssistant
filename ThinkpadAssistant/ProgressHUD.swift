//
//  ProgressHUD.swift
//  ProgressHUD, https://github.com/massimobio/ProgressHUD-Mac
//
//  Created by Massimo Biolcati on 9/10/18.
//  Copyright © 2018 Massimo. All rights reserved.
//

import AppKit

typealias ProgressHUDDismissCompletion = () -> Void

class HUD: NSView {

    // MARK: - Lifecycle

    static let shared = HUD()

    private override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        // setup view
        autoresizingMask = [.maxXMargin, .minXMargin, .maxYMargin, .minYMargin]
        alphaValue = 0.0
        isHidden = true

        // setup status message label
        statusLabel.font = font
        statusLabel.isEditable = false
        statusLabel.isSelectable = false
        statusLabel.alignment = .center
        statusLabel.backgroundColor = .clear
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

    // MARK: - Customization

    /// Set the font to use to display the HUD status message (Default is systemFontOfSize: 18)
    private var font = NSFont.systemFont(ofSize: 18)

    /// The amount of space between the HUD edge and the HUD elements (label, indicator or custom view)
    private var margin: CGFloat = 16.0
    
    /// The amount of space between the HUD elements (label, indicator or custom view)
    private var padding: CGFloat = 4.0

    /// The corner radius for th HUD
    private var cornerRadius: CGFloat = 15.0
    

    // MARK: - Presentation

    /// Changes the `ProgressHUD` status message while it's showing
    class func setStatus(_ status: String) {
        if HUD.shared.isHidden {
            return
        }
        HUD.shared.setStatus(status)
    }
    
    /// Presents a HUD with an image + status, and dismisses the HUD a little bit later
    class func showImage(_ image: NSImage, status: String) {
        let imageView = NSImageView(frame: NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        imageView.image = image
        HUD.shared.show(withStatus: status, imageView: imageView)
        HUD.dismiss(delay: HUD.shared.displayDuration(for: status))
    }

    /// Dismisses the currently visible `ProgressHUD` if visible
    class func dismiss() {
        HUD.shared.hide(true)
    }

    /// Dismisses the currently visible `ProgressHUD` if visible and calls the completion closure
    class func dismiss(completion: ProgressHUDDismissCompletion?) {
        HUD.shared.hide(true)
    }

    /// Dismisses the currently visible `ProgressHUD` if visible, after a time interval
    class func dismiss(delay: TimeInterval) {
        HUD.shared.perform(#selector(hideDelayed(_:)), with: 1, afterDelay: delay)
    }

    /// Dismisses the currently visible `ProgressHUD` if visible, after a time interval and calls the completion closure
    class func dismiss(delay: TimeInterval, completion: ProgressHUDDismissCompletion?) {
        HUD.shared.perform(#selector(hideDelayed(_:)), with: 1, afterDelay: delay)
    }

    /// Returns `true` is a `ProgressHUD` is currently being shown
    class func isVisible() -> Bool {
        return !HUD.shared.isHidden
    }

    // MARK: - Private Properties

    private var indicator: NSView?
    private var size: CGSize = .zero
    private let statusLabel = NSText(frame: .zero)
    private var completionHandler: ProgressHUDDismissCompletion?
    private var progress: Double = 0.0 {
        didSet {
            needsLayout = true
            needsDisplay = true
        }
    }
    
    private var hudView: NSView? {
        windowController?.showWindow(self)
        return windowController?.window?.contentView
    }
    private let minimumDismissTimeInterval: TimeInterval = 2
    private let maximumDismissTimeInterval: TimeInterval = 5
    private var windowController: NSWindowController?

    // MARK: - Private Show & Hide methods

    private func show(withStatus status: String, imageView: NSView) {
        guard let view = hudView else { return }
        
        if isHidden {
            frame = view.frame
            view.addSubview(self)
        }
        setupProgressIndicator(view: imageView)
        setStatus(status)
        show(true)
    }

    private func show(_ animated: Bool) {
        needsDisplay = true
        isHidden = false
        if animated {
            // Fade in
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = 0.20
            animator().alphaValue = 1.0
            NSAnimationContext.endGrouping()
        } else {
            alphaValue = 1.0
        }
    }
    
    private func hide(_ animated: Bool) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        if animated {
            // Fade out
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = 0.20
            NSAnimationContext.current.completionHandler = {
                self.done()
            }
            animator().alphaValue = 0
            NSAnimationContext.endGrouping()
        } else {
            alphaValue = 0.0
            done()
        }
    }

    private func done() {
        alphaValue = 0.0
        isHidden = true
        removeFromSuperview()
        completionHandler?()
        indicator?.removeFromSuperview()
        indicator = nil
        statusLabel.string = ""
        windowController?.close()
    }

    private func setStatus(_ status: String) {
        statusLabel.textColor = NSColor.secondaryLabelColor
        statusLabel.font = font
        statusLabel.string = status
        statusLabel.sizeToFit()
    }

    private func setupProgressIndicator(view: NSView) {
        indicator?.removeFromSuperview()
        indicator = view
        addSubview(indicator!)
    }

    @objc private func hideDelayed(_ animated: NSNumber?) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        hide((animated != 0))
    }

    private func displayDuration(for string: String) -> TimeInterval {
        let minimum = max(TimeInterval(string.count) * 0.06 + 0.5, minimumDismissTimeInterval)
        return min(minimum, maximumDismissTimeInterval)
    }

    // MARK: - Layout & Drawing

    func layoutSubviews() {

        // Entirely cover the parent view
        frame = superview?.bounds ?? .zero

        // Determine the total width and height needed
        let maxWidth = bounds.size.width - margin * 4
        var totalSize = CGSize.zero
        var indicatorFrame = indicator?.bounds ?? .zero
        
        indicatorFrame.size.width = min(indicatorFrame.size.width, maxWidth)
        totalSize.width = max(totalSize.width, indicatorFrame.size.width)
        totalSize.height += indicatorFrame.size.height
        if indicatorFrame.size.height > 0.0 {
            totalSize.height += padding
        }

        var statusLabelSize: CGSize = statusLabel.string.count > 0 ? statusLabel.string.size(withAttributes: [NSAttributedString.Key.font: statusLabel.font!]) : CGSize.zero
        if statusLabelSize.width > 0.0 {
            statusLabelSize.width += 10.0
        }
        statusLabelSize.width = min(statusLabelSize.width, maxWidth)
        totalSize.width = max(totalSize.width, statusLabelSize.width)
        totalSize.height += statusLabelSize.height
        if statusLabelSize.height > 0.0 && indicatorFrame.size.height > 0.0 {
            totalSize.height += padding
        }
        totalSize.width += margin * 2
        totalSize.height += margin * 2

        // Position elements
        var yPos = round((bounds.size.height - totalSize.height) / 2) + margin - (bounds.size.height / 5)
        if indicatorFrame.size.height > 0.0 {
            yPos += padding
        }
        if statusLabelSize.height > 0.0 && indicatorFrame.size.height > 0.0 {
            yPos += padding + statusLabelSize.height
        }
        let xPos: CGFloat = 0
        indicatorFrame.origin.y = yPos
        indicatorFrame.origin.x = round((bounds.size.width - indicatorFrame.size.width) / 2) + xPos
        indicator?.frame = indicatorFrame

        if indicatorFrame.size.height > 0.0 {
            yPos -= padding * 2
        }

        if statusLabelSize.height > 0.0 && indicatorFrame.size.height > 0.0 {
            yPos -= padding + statusLabelSize.height
        }
        var statusLabelFrame = CGRect.zero
        statusLabelFrame.origin.y = yPos
        statusLabelFrame.origin.x = round((bounds.size.width - statusLabelSize.width) / 2) + xPos
        statusLabelFrame.size = statusLabelSize
        statusLabel.frame = statusLabelFrame

        size = totalSize
    }

    override func draw(_ rect: NSRect) {
        layoutSubviews()
        NSGraphicsContext.saveGraphicsState()
        guard let context = NSGraphicsContext.current?.cgContext else { return }

        // Set background rect color
        context.setFillColor(NSColor.windowBackgroundColor.cgColor)

        // Center HUD
        let allRect = bounds

        // Draw rounded HUD backgroud rect
        let boxRect = CGRect(x: round((allRect.size.width - size.width) / 2),
                             y: round((allRect.size.height - size.height) / 2) - (bounds.size.height / 5),
                             width: size.width, height: size.height)
        let radius = cornerRadius
        context.beginPath()
        context.move(to: CGPoint(x: boxRect.minX + radius, y: boxRect.minY))
        context.addArc(center: CGPoint(x: boxRect.maxX - radius, y: boxRect.minY + radius), radius: radius, startAngle: .pi * 3 / 2, endAngle: 0, clockwise: false)
        context.addArc(center: CGPoint(x: boxRect.maxX - radius, y: boxRect.maxY - radius), radius: radius, startAngle: 0, endAngle: .pi / 2, clockwise: false)
        context.addArc(center: CGPoint(x: boxRect.minX + radius, y: boxRect.maxY - radius), radius: radius, startAngle: .pi / 2, endAngle: .pi, clockwise: false)
        context.addArc(center: CGPoint(x: boxRect.minX + radius, y: boxRect.minY + radius), radius: radius, startAngle: .pi, endAngle: .pi * 3 / 2, clockwise: false)
        context.closePath()
        context.fillPath()

        NSGraphicsContext.restoreGraphicsState()
    }

}
