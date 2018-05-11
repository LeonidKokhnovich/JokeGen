//
//  SearchJokeManagerTests.swift
//  JokeGenTests
//
//  Created by Leonid Kokhnovych on 2018-05-10.
//  Copyright © 2018 Leonid Kokhnovych. All rights reserved.
//

import XCTest
import ReactiveSwift
@testable import JokeGen

class SearchJokeManagerTests: XCTestCase {
    struct Config {
        static let queryTimeout = 3.0
    }
    
    var manager: SearchJokeManager!
    
    override func setUp() {
        super.setUp()
        
        // We can't inject ApolloClient since we can't mock it, but we can do integration tests at least.
        manager = SearchJokeManager()
    }
    
    override func tearDown() {
        manager = nil
        super.tearDown()
    }
    
    func testQuery() {
        let expect = expectation(description: "Query time")
        manager.search(by: "").startWithResult { (result) in
            expect.fulfill()
            
            switch result {
            case .failure:
                XCTFail("Should give some random joke")
            case .success(let joke):
                XCTAssertNotNil(joke.joke, "Should give some random joke")
            }
        }
        
        waitForExpectations(timeout: Config.queryTimeout, handler: nil)
    }
}
