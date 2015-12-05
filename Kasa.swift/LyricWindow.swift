//
//  LyricWindow.swift
//  Kasa.swift
//
//  Created by Luavis Kang on 12/2/15.
//  Copyright © 2015 Luavis. All rights reserved.
//

import Foundation

class LyricWindow: OverlayWindow {

    @IBOutlet weak var lyricLabel: ShadowLabel!
    @IBOutlet weak var informationLabel: ShadowLabel!

    override func awakeFromNib() {
        self.backgroundColor = NSColor.blackColor().colorWithAlphaComponent(0.00)
        self.collectionBehavior.insert(.CanJoinAllSpaces)
        super.awakeFromNib()
    }

    override func mouseEntered(theEvent: NSEvent) {
        self.informationLabel.hidden = false

        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.5
            self.informationLabel.animator().alphaValue = 1.0
            self.animator().backgroundColor = NSColor.blackColor().colorWithAlphaComponent(0.15)
        }) { () -> Void in
            super.mouseEntered(theEvent)
        }
    }

    override func mouseExited(theEvent: NSEvent) {
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.5
            self.informationLabel.animator().alphaValue = 0.0
            self.animator().backgroundColor = NSColor.blackColor().colorWithAlphaComponent(0.00)
            }) { () -> Void in
                self.informationLabel.hidden = true
                super.mouseExited(theEvent)
        }
    }

    func setLyricText(value: String) {
        dispatch_async(dispatch_get_main_queue()) {
            self.lyricLabel.stringValue = value
        }
    }
}
