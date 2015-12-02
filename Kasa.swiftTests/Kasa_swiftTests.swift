//
//  Kasa_swiftTests.swift
//  Kasa.swiftTests
//
//  Created by Luavis on 2014. 9. 8..
//  Copyright (c) 2014년 Luavis. All rights reserved.
//

import Cocoa
import XCTest
@testable import Kasa_swift


class Kasa_swiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDownloadLyric() {
        let manager = LyricManager.manager
        manager.getLyric("/Users/Luavis/Music/iTunes/iTunes Media/Music/Various Artists/프로듀사 (KBS 2TV 금토드라마) OST/1-05 우리 둘.mp3")

        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
