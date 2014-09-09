//
//  LRC.swift
//  Kasa.swift
//
//  Created by Luavis on 2014. 9. 8..
//  Copyright (c) 2014년 Luavis. All rights reserved.
//

import Foundation

struct LRCComponent {
  let lyric: String
  let startPoint: Double
  
  init(lyric:String, startPoint:Double) {
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
      let startIndex = advance(self.startIndex, r.startIndex)
      let endIndex = advance(startIndex, (r.endIndex - r.startIndex))
      
      return self[Range(start: startIndex, end: endIndex)]
    }
  }
  
  func toDouble() -> Double
  {
    return NSString(string: self).doubleValue
  }
}

class LRCArray : NSObject {
  
  // Static
  
  struct Static {
    static let delayTime:Double = 0.08
  }
  
  class func decode(lrc: String) -> LRCArray? {
    
    let segs = lrc.componentsSeparatedByString("<br>")
    
    let size = segs.count
    
    var lrcComponentArray: [LRCComponent] = [LRCComponent](count: size, repeatedValue: LRCComponent(lyric: "", startPoint: 0.0))
    
    
    for (index, elem:String) in enumerate(segs) {
      var error:NSError? = nil
      println(elem)
      let regexp = NSRegularExpression.regularExpressionWithPattern("\\[([0-9]+):([0-9\\.]+)\\](.*)", options: .CaseInsensitive, error: &error)
      
      if let error = error {
        println("Error \(error)")
        return nil
      }
      
      if let regexp:NSRegularExpression! = regexp {
        var match:NSTextCheckingResult? = regexp.firstMatchInString(elem, options:nil, range: NSRange(location: 0, length: countElements(elem)))
        
        if let match = match {
          
          var lyric = ""
          var startPoint = -Static.delayTime
          
          let minRange:NSRange = match.rangeAtIndex(1)
          let secRange:NSRange = match.rangeAtIndex(2)
          let lyricRange:NSRange = match.rangeAtIndex(3)
          
          let opMin:Int? = elem[minRange.location...minRange.location + minRange.length - 1].toInt()
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
          
          let lrcComponent:LRCComponent! = LRCComponent(lyric: lyric, startPoint: startPoint)
          lrcComponentArray[index] = lrcComponent
          
        }
      }
      else {
        break // missed
      }
    }
    
    println(lrcComponentArray[0])
    
    return LRCArray(lrcComponentArray);
  }
  
  // Member
  
  let lrcArray:[LRCComponent] = []
  var recentIndexFirst:Int = 0;
  var recentIndexSecond:Int = 0;
  private let size:Int;
  
  
  init(_ lrcs:[LRCComponent]) {
    
    var i = 0
    let size = lrcs.count
    
    while i < (size - 1) {
      
      var append_lyric:String = lrcs[i].lyric
      var j = 1
      println(i)
      
      while j < (size) {
        if lrcs[i].startPoint == 0 || countElements(lrcs[i].lyric) == 0 {
          break
        }
        
        if lrcs[i].startPoint == lrcs[i + j].startPoint {
          append_lyric = "\(append_lyric)\n\(lrcs[i + j].lyric)"
        }
        else {
          self.lrcArray.append(LRCComponent(lyric: append_lyric, startPoint: lrcs[i].startPoint))
          break
        }
        
        j++
      }
      
      i += j
    }
    
    self.size = self.lrcArray.count
  }
  
  internal subscript(time: Double) -> LRCComponent? {
    get {
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
            var com = self.lrcArray[i - 1]
            
            return com
          }
          
          i++
        }
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
            var com = self.lrcArray[i - 1]
            
            return com
          }
          
          i--
        }
      }
      
      return nil
    }
  }
}
