//
//  SpaceXCrewTests.swift
//  SpaceXCrewTests
//
//  Created by Kristoffer Anger on 2023-08-20.
//

import XCTest
@testable import SpaceXCrew

final class SpaceXCrewTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStringCleaning() throws {
        // the app uses url as image name by removing all
        // characters that is not a letter or a number
        let urlString = "https://imgur.com/ll7TlwD.png"
        
        let expectedValue = "httpsimgurcomll7TlwDpng"
        let actualValue = urlString.onlyLettersAndNumbers()
        // perform test
        XCTAssertEqual(expectedValue, actualValue)
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
