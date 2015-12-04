//
//  ShadowLabel.swift
//  Kasa.swift
//
//  Created by Luavis Kang on 12/2/15.
//  Copyright © 2015 Luavis. All rights reserved.
//

import Cocoa

class ShadowLabel: NSTextField {

    var shadowColor = NSColor.blackColor();
    var shadowOffset = CGSize(width: 1.0, height: 1.0)
    var shadowRadius:Float = 2.0
    var shadowOpacity:Float = 1.0


    override func awakeFromNib() {
        self.drawShadow()
    }

    func drawShadow() {
        self.wantsLayer = true;
        let layer:CALayer! = self.layer!;

        layer.backgroundColor = NSColor.clearColor().CGColor;
        layer.shadowColor = self.shadowColor.CGColor;

        layer.shadowOffset = self.shadowOffset
        layer.shadowOpacity = self.shadowOpacity
        layer.shadowRadius = CGFloat(self.shadowRadius)
    }
}
