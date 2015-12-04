//
//  iTunesConnection.swift
//  Kasa.swift
//
//  Created by Luavis Kang on 12/4/15.
//  Copyright © 2015 Luavis. All rights reserved.
//

import Foundation

protocol iTunesConnectionDelegate {
    func musicChanged(path: String?)
}


class iTunesConnection: NSObject {

    static let connection = iTunesConnection()
    static let iTunesListenScript =
        NSAppleScript(source: "tell application \"iTunes\" to if running then\ntell current track to return &location\nend if")!

    static let iTunesPlayingPositionScript =
        NSAppleScript(source: "tell application \"iTunes\" to if running then\nreturn player position\nend if")!

    var delegate:iTunesConnectionDelegate?

    var playingPosition: Double {
        var error:NSDictionary?

        let result = iTunesConnection.iTunesPlayingPositionScript.executeAndReturnError(&error)

        let position:Double

        if error != nil {
            return -1
        }

        if #available(OSX 10.11, *) {
            position = result.doubleValue
        } else {
            // Fallback on earlier versions
            position = Double(result.int32Value)
        }

        return position
    }

    func listen() -> Bool {
        let notiCenter = NSDistributedNotificationCenter.defaultCenter()
        notiCenter.addObserver(self, selector: "updateTrack:", name: "com.apple.iTunes.playerInfo", object: nil)

        var error:NSDictionary?
        let result = iTunesConnection.iTunesListenScript.executeAndReturnError(&error)
        if error != nil {
            return false
        }

        let resultValue = result.stringValue

        if let resultValue = resultValue {
            self.delegate?.musicChanged("/Volumes/" +
                resultValue.stringByReplacingOccurrencesOfString(":", withString: "/")
                .stringByReplacingOccurrencesOfString("\r", withString: "")
            )
            return true
        }
        else {
            return false
        }
    }

    func updateTrack(notification: NSNotification) {
        if let delegate = self.delegate {
            let information = notification.userInfo!
            let state:String = information["Player State"] as! String
            if state == "Playing" {
                let location:String = information["Location"]! as! String
                delegate.musicChanged(location)
            }
            else {
                delegate.musicChanged(nil)
            }
        }
    }
}
