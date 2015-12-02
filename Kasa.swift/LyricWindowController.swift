//
//  LyricWindowController.swift
//  Kasa.swift
//
//  Created by Luavis Kang on 12/2/15.
//  Copyright © 2015 Luavis. All rights reserved.
//

import Cocoa


class LyricWindowController: NSWindowController {

    init() {
        super.init(window: nil)

        NSBundle.mainBundle().loadNibNamed("MainWindow", owner: self, topLevelObjects: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
