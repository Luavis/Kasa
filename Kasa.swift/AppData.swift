//
//  AppData.swift
//  Kasa.swift
//
//  Created by Luavis on 2014. 9. 8..
//  Copyright (c) 2014년 Luavis. All rights reserved.
//

import Foundation

class AppData: NSObject {
    struct Static {
        static var token: dispatch_once_t = 0
        static var instance:AppData? = nil
    }
    
    class var instance: AppData! {
        dispatch_once(&Static.token) { () -> Void in Static.instance = AppData()}
        return Static.instance!
    }
    
    var enterAlpha:NSNumber = 1.0
    var exitAlpha:NSNumber = 1.0
    var isAlpha:Bool = false
    var cacheValidTime:NSNumber = 60 * 60 * 24
}