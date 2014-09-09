//
//  NSColor+CGColor.swift
//  Kasa.swift
//
//  Created by Luavis on 2014. 9. 8..
//  Copyright (c) 2014년 Luavis. All rights reserved.
//

import Foundation

extension NSColor {
    func CGColor() -> CGColorRef? {
        let numberOfComponents: NSInteger = self.numberOfComponents
        let components: UnsafeMutablePointer<CGFloat> = UnsafeMutablePointer<CGFloat>(calloc(UInt(numberOfComponents), UInt(sizeof(CGFloat))))
        var colorSpace:CGColorSpaceRef = self.colorSpace.CGColorSpace;
        
        self.getComponents(components)
        return CGColorCreate(colorSpace, components)
    }
    
    class func colorWithWithCGColor(CGColor: CGColorRef!) -> NSColor {
        return NSColor.colorWithWithCGColor(CGColor)
    }
}
