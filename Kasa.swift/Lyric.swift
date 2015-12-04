//
//  Lyric.swift
//  Kasa.swift
//
//  Created by Luavis Kang on 12/4/15.
//  Copyright © 2015 Luavis. All rights reserved.
//

import Foundation


struct Lyric {
    static let empty = Lyric("", startPoint: 0.0)

    let lyric: String
    let startPoint: Double

    init(_ lyric:String, startPoint:Double) {
        self.lyric = lyric
        self.startPoint = startPoint
    }

    var description: String {
        return self.lyric
    }
}

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = startIndex.advancedBy((r.endIndex - r.startIndex))

            return self[Range(start: startIndex, end: endIndex)]
        }
    }

    func toDouble() -> Double {
        return NSString(string: self).doubleValue
    }
}

class Lyrics {

    // Static

    static let delayTime:Double = 0.09
    static let empty = Lyrics([])

    static func decode(lrc: String) -> Lyrics? {

        let segs = lrc.componentsSeparatedByString("<br>")

        let size = segs.count

        var lrcComponentArray: [Lyric] = [Lyric](count: size, repeatedValue: Lyric.empty)


        for (index, elem): (Int, String) in segs.enumerate() {
            let error:NSError? = nil
            let regexp: NSRegularExpression

            do {
                regexp = try NSRegularExpression(pattern: "\\[([0-9]+):([0-9\\.]+)\\](.*)", options: .CaseInsensitive)
            } catch {
                return nil
            }

            if let _ = error {
                return nil
            }

            if let regexp:NSRegularExpression! = regexp {
                let match:NSTextCheckingResult? = regexp.firstMatchInString(elem, options:.ReportProgress, range: NSRange(location: 0, length: elem.characters.count))

                if let match = match {

                    var lyric = ""
                    var startPoint = -Lyrics.delayTime

                    let minRange:NSRange = match.rangeAtIndex(1)
                    let secRange:NSRange = match.rangeAtIndex(2)
                    let lyricRange:NSRange = match.rangeAtIndex(3)

                    let opMin:Int? = Int(elem[minRange.location...minRange.location + minRange.length - 1])
                    let opSec:Double? = elem[secRange.location...secRange.location + secRange.length - 1].toDouble()

                    if let min = opMin {
                        startPoint += Double(min * 60)
                    }
                    else {
                        continue
                    }

                    if let sec = opSec {
                        startPoint += sec
                    }
                    else {
                        continue
                    }

                    if lyricRange.length != 0 {
                        lyric = elem[lyricRange.location...lyricRange.location + lyricRange.length - 1]
                    }

                    let lrcComponent:Lyric = Lyric(lyric, startPoint: startPoint)
                    lrcComponentArray[index] = lrcComponent

                }
            }
            else {
                break // missed
            }
        }

        return Lyrics(lrcComponentArray);
    }

    // Member

    var lrcArray:[Lyric] = []
    var recentIndexFirst:Int = 0;
    var recentIndexSecond:Int = 0;
    private let size:Int;


    init(_ lrcs:[Lyric]) {

        var i = 0
        let size = lrcs.count

        while i < (size - 1) {

            var append_lyric:String = lrcs[i].lyric
            var j = 1

            while j < (size) {
                if lrcs[i].startPoint == 0 || lrcs[i].lyric.characters.count == 0 {
                    break
                }

                if lrcs[i].startPoint == lrcs[i + j].startPoint {
                    append_lyric = "\(append_lyric)\n\(lrcs[i + j].lyric)"
                }
                else {
                    self.lrcArray.append(Lyric(append_lyric, startPoint: lrcs[i].startPoint))
                    break
                }

                j++
            }

            i += j
        }

        self.size = self.lrcArray.count
    }

    var isEmpty:Bool {
        return self.lrcArray.isEmpty
    }

    internal subscript(time: Double) -> Lyric? {
        get {
            if self === Lyrics.empty {
                return Lyric.empty
            }

            if time >= self.lrcArray[self.recentIndexSecond].startPoint {
                var i = self.recentIndexSecond;

                while i < self.size {
                    self.lrcArray[i].startPoint
                    if self.lrcArray[i].startPoint >= time {
                        if i < 1 {
                            return nil
                        }
                        
                        self.recentIndexFirst = i - 1
                        self.recentIndexSecond = i
                        let com = self.lrcArray[i - 1]
                        
                        return com
                    }
                    
                    i++
                }

                return self.lrcArray.last!
            }
            else if time < self.lrcArray[self.recentIndexFirst].startPoint {
                var i = self.recentIndexFirst - 1
                
                while i > 0 {
                    if self.lrcArray[i].startPoint >= time {
                        if i < 1 {
                            return nil
                        }
                        
                        self.recentIndexFirst = i - 1
                        self.recentIndexSecond = i
                        let com = self.lrcArray[i - 1]
                        
                        return com
                    }
                    
                    i--
                }
            }
            
            return self.lrcArray[self.recentIndexFirst]
        }
    }
}
