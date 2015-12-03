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

    func testLyricParsing() {
        let lyrics = Lyrics.decode("[00:12.39]마주 보고 서 있는대도<br>[00:17.15]마음까진 보이지 않아<br>[00:22.32]혼자 있는 빈 시간마다<br>")!
        XCTAssert(lyrics[13]?.lyric == "마주 보고 서 있는대도")
        XCTAssert(lyrics[15]?.lyric == "마주 보고 서 있는대도")
        XCTAssert(lyrics[18]?.lyric == "마음까진 보이지 않아")
        XCTAssert(lyrics[23]?.lyric == "혼자 있는 빈 시간마다")
    }

    func testDownloadLyric() {
        let manager = LyricManager.manager
        let testBundle = NSBundle(forClass: self.dynamicType)
        let filePath = testBundle.pathForResource("test", ofType: "mp3")!

        let readyExpectation = expectationWithDescription("ready for download")

        manager.getLyric(filePath) { lyrics in
            XCTAssert(lyrics[13]?.lyric == "마주 보고 서 있는대도")
            XCTAssert(lyrics[15]?.lyric == "마주 보고 서 있는대도")
            XCTAssert(lyrics[18]?.lyric == "마음까진 보이지 않아")
            XCTAssert(lyrics[23]?.lyric == "혼자 있는 빈 시간마다")

            readyExpectation.fulfill()
        }

        waitForExpectationsWithTimeout(20.0) { error in
            XCTAssertNil(error, "Timeout error")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
