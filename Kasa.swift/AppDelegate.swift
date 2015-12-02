//
//  AppDelegate.swift
//  Kasa.swift
//
//  Created by Luavis on 2014. 9. 8..
//  Copyright (c) 2014년 Luavis. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
                            
    //@IBOutlet weak var window: NSWindow!
    var window: NSWindow!

    func applicationDidFinishLaunching(notification: NSNotification) {
        let windowController = LyricWindowController();
        self.window = windowController.window

        windowController.showWindow(nil)
        self.window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

}
