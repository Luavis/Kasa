//
//  MainWindowController.swift
//  Kasa.swift
//
//  Created by Luavis on 2014. 9. 8..
//  Copyright (c) 2014년 Luavis. All rights reserved.
//

import Foundation
import Quartz

class MainWindowController: NSWindowController {

    init() {
        super.init(window: nil)
        
        /* Load window from xib file */
        NSBundle.mainBundle().loadNibNamed("MainWindow", owner: self, topLevelObjects: nil)
    }

    
    @IBOutlet weak var lyricView: LyricTextField!
    @IBOutlet weak var informationLabel: NSTextField!

    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }

    override func awakeFromNib() {
        self.lyricView.wantsLayer = true
        self.lyricView.layer?.backgroundColor = NSColor.clearColor().CGColor
        self.lyricView.layer?.shadowColor = NSColor.blackColor().CGColor;
        
        self.lyricView.layer?.shadowOffset = CGSize(width: 6.0, height:6.0)
        self.lyricView.layer?.shadowOpacity = 5.0
        self.lyricView.layer?.shadowRadius = 30.0
        
        self.informationLabel.wantsLayer = true
        self.informationLabel.layer?.backgroundColor = NSColor.clearColor().CGColor
        self.informationLabel.layer?.shadowColor = NSColor.blackColor().CGColor
        self.informationLabel.layer?.shadowOffset = CGSize(width: 6.0, height: 6.0)
        self.informationLabel.layer?.shadowOpacity = 5.0
        self.informationLabel.layer?.shadowRadius = 30.0
        
        // window init
        self.window!.backgroundColor = NSColor.blackColor().colorWithAlphaComponent(0.08)
        var collectionBehavior:NSWindowCollectionBehavior = self.window!.collectionBehavior
        collectionBehavior |= .CanJoinAllSpaces
        self.window.collectionBehavior = collectionBehavior
        
        var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            NSAnimationContext.runAnimationGroup({ (context:NSAnimationContext) -> Void in
                self.informationLabel.animator().alphaValue = 0.0
            }, completionHandler: { () -> Void in
                NSObject.cancelPreviousPerformRequestsWithTarget(self)
                self.informationLabel.hidden = true
            })
        }
      
      LSiTunesConnection.instance().delegate = self.lyricView
      LSiTunesConnection.instance().startListening()
    }
}