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
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
        
        AppData.instance // initialize
        AppData.instance.mainWindowController = MainWindowController()
        self.window = AppData.instance.mainWindowController?.window
        
        AppData.instance.mainWindowController?.showWindow(nil)
        AppData.instance.mainWindowController?.window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }

}
