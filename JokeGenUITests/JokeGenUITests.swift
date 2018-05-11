//
//  JokeGenUITests.swift
//  JokeGenUITests
//
//  Created by Leonid Kokhnovych on 2018-05-10.
//  Copyright © 2018 Leonid Kokhnovych. All rights reserved.
//

import XCTest

class JokeGenUITests: XCTestCase {
    struct Config {
        static let searchTimeout = 3.0
        static let notFoundError = "Not found"
    }
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func checkSearchResultContaining(text: String) {
        let substringPredicate = NSPredicate(format: "%K contains %@", "text", text)
        let label = XCUIApplication().textViews.containing(substringPredicate)
        let existsPredicate = NSPredicate(format: "exists == 1")
        
        expectation(for: existsPredicate, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: Config.searchTimeout, handler: nil)
    }
    
    func testSearchWithInvalidQuery() {
        let searchQueryTextField = XCUIApplication().textFields.firstMatch
        XCTAssertTrue(searchQueryTextField.exists)
        searchQueryTextField.tap()
        searchQueryTextField.typeText("c")
        
        checkSearchResultContaining(text: Config.notFoundError)
    }
    
    func testSearchWithValidQueries() {
        let searchQueryTextField = XCUIApplication().textFields.firstMatch
        XCTAssertTrue(searchQueryTextField.exists)
        searchQueryTextField.tap()
        searchQueryTextField.typeText("cat")
        
        checkSearchResultContaining(text: "cat")
        
        searchQueryTextField.typeText("dog")
        
        checkSearchResultContaining(text: "dog")
    }
}
