//
//  CaptionBotTests.swift
//  CaptionBotTests
//
//  Created by Noel Portugal on 10/2/16.
//  Copyright © 2016 theiotlabs. All rights reserved.
//

import XCTest
@testable import CaptionBot

class CaptionBotTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAss∫ert and related functions to verify your tests produce the correct results.
        captionBot(url: "test") { caption, error in
            if let caption = caption {
                print("Caption: \(caption)")
            } else {
                print("Error: \(error)")
            }
        }
        let image = UIImage(named: "")!
        captionBot(image: image) { caption, error in
            if let caption = caption {
                print("Caption: \(caption)")
            } else {
                print("Error: \(error)")
            }
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
