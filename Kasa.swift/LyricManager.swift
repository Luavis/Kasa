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
import CryptoSwift


struct Lyric {
    var startTime: UInt
    var statement: String
}

class LyricManager {

    static let manager = LyricManager()
    private static var lyricDownloadUrl =
        "http://lyrics.alsong.co.kr/ALSongWebService/Service1.asmx"


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
            
            let opt = try HTTP.POST(LyricManager.lyricDownloadUrl)

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

    func id3Md5Hash(soundFilePath: String) -> (Bool, String) {
        if let inputStream = NSInputStream(fileAtPath: soundFilePath) {
            inputStream.open()

            var buf:[UInt8] = [UInt8].init(count: 255, repeatedValue: 0)
            var len = inputStream.read(&buf, maxLength: 3) // drop 'ID3'

            if len < 3 {
                return (false, "")
            }

            len = inputStream.read(&buf, maxLength: 7)
            let startPoint = self.id3Md5HashSTartPoint(buf)

            if startPoint == 0 {
                return (false, "")
            }

            inputStream.setProperty(
                NSNumber(int: startPoint),
                forKey:NSStreamFileCurrentOffsetKey)

            buf[0] = 0x00 // clear buffer

            while buf[0] != 0xff {
                inputStream.read(&buf, maxLength: 1)
            }

            inputStream.setProperty(
                NSNumber(int: startPoint),
                forKey:NSStreamFileCurrentOffsetKey)

            var bigBuf:[UInt8] = [UInt8].init(count: 163840, repeatedValue: 0)
            len = inputStream.read(&bigBuf, maxLength: bigBuf.count)

            if len < bigBuf.count {
                return (false, "")
            }

            return (true, bigBuf.md5().toHexString())
        }
        else {
            return (false, "")
        }
    }

    private func id3Md5HashSTartPoint(buf: [UInt8]) -> Int32 {
        if buf.count < 4 {
            return 0
        }

        let (x, y, z, w) = (Int32(buf[3]), Int32(buf[4]), Int32(buf[5]), Int32(buf[6]))
        return ((x << 21) | (y << 14) | (z << 7) | w) + 10
    }
}

