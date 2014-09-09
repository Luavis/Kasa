//
//  LyricTextField.swift
//  Kasa.swift
//
//  Created by Luavis on 2014. 9. 8..
//  Copyright (c) 2014년 Luavis. All rights reserved.
//

import Foundation


class LyricTextField: NSTextField, LSiTunesConnectionDelegate {

    required init(coder: NSCoder!) {
      super.init(coder : coder)
    }
    
    var height:CGFloat = 0.0 // = self.frame.size.height;
  
    var t_font:NSFont = NSFont() // = [self font];
    var t_width:CGFloat = 0.0  // = self.frame.size.width;
    var t_size:CGSize = CGSize(width: 0, height: 0) //= NSMakeSize(t_width, FLT_MAX);
    var t_range:NSRange = NSRange(location: 0, length: 0) // = NSMakeRange(0, 0);
    var t_textContainer:NSTextContainer = NSTextContainer()  // = [[NSTextContainer alloc] initWithContainerSize:t_size];
    var t_layoutManager:NSLayoutManager = NSLayoutManager()
  
    var stop = false
  
    func musicChanged(location: String!) {
        if !self.locationCheck(location) {
            return;
        }
        
        dispatch_async(dispatch_queue_create("KasaDownload", nil), {
          let dict:NSDictionary? = LSKasaGetter.synchronizedDownloadWithURL(location)
          if let ndict = dict as? Dictionary<NSString, AnyObject> {
            let lyric: String = ndict["strLyric"] as NSString
            if countElements(lyric) == 0 {
              self.refresh("가사가 없습니다.")
            }
            else {
              let lrca: LRCArray? = LRCArray.decode(lyric)
              self.refresh("") // initialize lyric view
              self.stop = true
              
              if let lrca = lrca {
                dispatch_async(dispatch_queue_create("KasaUpdater", nil)) {
                  let theScript:NSAppleScript = NSAppleScript(source: "tell application \"iTunes\" to if running then\nreturn player position\nend if")
                  let errorDict:AutoreleasingUnsafeMutablePointer<NSDictionary?> = nil
                  self.stop = false
                  
                  while true {
                    let ret:NSAppleEventDescriptor? = theScript.executeAndReturnError(errorDict)
                    if let ret = ret {
                      let position:Double = ret.doubleValue()
                      let component:LRCComponent? = lrca[position]
                      if let component = component {
                        self.refresh(component.lyric)
                      }
                    }
                    
                    if self.stop {
                      return
                    }
                    
                    NSThread.sleepForTimeInterval(NSTimeInterval(0.001))
                  }
                }
              }
            }
          }
          else {
            dispatch_sync(dispatch_get_main_queue()) {
              
              let delayInSeconds:UInt64 = 5
              
              var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC)));
              
              dispatch_after(popTime, dispatch_get_main_queue()) {
                //                  [self musicChanged:location];
                self.musicChanged(location)
                
              }
            }
            
            return;
          }
        })
    }
  
    func refresh(st: String!) {
      if NSThread.currentThread() != NSThread.mainThread() {
        dispatch_async(dispatch_get_main_queue(), {
          self.refresh(st)
        })
        
      }
      else {
        let textStorage:NSTextStorage = NSTextStorage(string: st)
        self.t_layoutManager.replaceTextStorage(textStorage)
        textStorage.addLayoutManager(self.t_layoutManager)
        self.t_range.length = textStorage.length
        textStorage.addAttribute(NSFontAttributeName, value:self.t_font, range: self.t_range)
        self.t_layoutManager.glyphRangeForTextContainer(self.t_textContainer)
        
        let h:CGFloat = self.t_layoutManager.usedRectForTextContainer(t_textContainer).size.height
        
        if(h != self.height)
        {
          let delta:CGFloat = height - h;
          height = h;
          var windowFrame:NSRect = self.window!.frame;
          
          windowFrame.size.height -= delta;
          self.window?.setFrame(windowFrame, display: true, animate: true)
        }
        
        self.stringValue = st;
      }
    }
  
    override func awakeFromNib() {
      self.height = self.frame.size.height
      
      self.t_font = self.font
      self.t_width = self.frame.size.width
      self.t_size = NSSize(width: t_width, height: CGFloat(FLT_MAX))
      
      self.t_range = NSRange(location: 0, length: 0)
      self.t_textContainer = NSTextContainer(containerSize: self.t_size)
      self.t_textContainer.lineFragmentPadding = 0.0
      self.t_layoutManager.addTextContainer(self.t_textContainer)
    }
    
    func locationCheck(location: AnyObject?) -> Bool{
        if location == nil {
            return false
        }
        
        if location is String {
            return true
        }
        
        return false
    }
}