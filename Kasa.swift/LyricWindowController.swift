//
//  LyricWindowController.swift
//  Kasa.swift
//
//  Created by Luavis Kang on 12/2/15.
//  Copyright © 2015 Luavis. All rights reserved.
//

import Cocoa


class LyricWindowController: NSWindowController, iTunesConnectionDelegate {


    static let lyricNotFoundMsg = "가사가 없습니다."
    var lyrics:Lyrics = Lyrics.empty

    init() {
        super.init(window: nil)

        NSBundle.mainBundle().loadNibNamed("MainWindow", owner: self, topLevelObjects: nil)

        iTunesConnection.connection.delegate = self
        iTunesConnection.connection.listen()

//        NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: "iTunesTimer", userInfo: nil, repeats: true)

        dispatch_async(dispatch_queue_create("com.luavis.kasa.updater", nil)) {
            while true {
                self.iTunesTimer()
                NSThread.sleepForTimeInterval(NSTimeInterval(0.005))
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func musicChanged(path: String?) {
        if let path = path {
            LyricManager.manager.getLyric(path) { lyrics in

                let window = self.window as! LyricWindow

                if lyrics === Lyrics.empty {
                    window.setLyricText(LyricWindowController.lyricNotFoundMsg)
                }
                else {
                    self.changeLyrics(lyrics)
                }
            }
        }
    }

    func changeLyrics(lyrics:Lyrics) {
        self.lyrics = lyrics
    }

    func iTunesTimer() {
        let window = self.window as! LyricWindow
        let position = iTunesConnection.connection.playingPosition
        let lyric = self.lyrics[position]

        if let lyric = lyric {
            window.setLyricText(lyric.lyric)
        }
        else {
            window.setLyricText(LyricWindowController.lyricNotFoundMsg)
        }
    }
}
