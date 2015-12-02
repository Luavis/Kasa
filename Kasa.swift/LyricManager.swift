//
//  LyricManager.swift
//  Kasa.swift
//
//  Created by Luavis Kang on 12/3/15.
//  Copyright © 2015 Luavis. All rights reserved.
//

import Foundation
import FileKit
import SwiftHTTP


struct Lyric {
    var startTime: UInt
    var statement: String
}

class LyricManager {

    static let manager = LyricManager()

    func getLyric(soundFilePath: String, cb:[Lyric] -> Bool) {

        self.downloadLyric(soundFilePath, cb: cb)
    }

    func downloadLyric(soundFilePath: String, cb:[Lyric] -> Bool){
        let soundFile = DataFile(path: Path(soundFilePath))

        if !soundFile.exists {
            cb([])
            return
        }

        do {
            let data = try soundFile.read()
            var header:[uint8] = [uint8](count: 3, repeatedValue: 0)

            data.getBytes(&header, range: NSRange(location: 0, length: 3))

            if(self.checkID3Tag(header)) {
                return self.downloadMp3Lyric(soundFilePath, cb: cb)
            }
            else {
                return self.downloadNonMp3Lyric(soundFilePath, cb: cb)
            }
        }
        catch {
            cb([])
        }
    }

    private func downloadMp3Lyric(soundFilePath: String, cb:[Lyric] -> Bool) {
        do {
            let opt = try HTTP.GET(soundFilePath)

            opt.start() { response in
                
                
            }
        }
        catch {
            cb([])
        }
    }

    private func downloadNonMp3Lyric(soundFilePath: String, cb:[Lyric] -> Bool) {
        
    }

    private func checkID3Tag(header: [uint8]) -> Bool {

        if header.count < 3 {
            return false
        }

        if header[0] == 0x49 &&
            header[1] == 0x44 &&
            header[2] == 0x33 {
                return true
        }
        else {
            return false
        }
    }
}

