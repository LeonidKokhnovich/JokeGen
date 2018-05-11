//
//  SearchJokeViewModelTests.swift
//  JokeGenTests
//
//  Created by Leonid Kokhnovych on 2018-05-10.
//  Copyright © 2018 Leonid Kokhnovych. All rights reserved.
//

import XCTest
import ReactiveSwift
@testable import JokeGen

class SearchJokeViewModelTests: XCTestCase {
    struct Config {
        static let query = "test"
        static let joke = SearchJokeQuery.Data.Joke(joke: "some joke")
    }
    
    var searchJokeManager: SearchJokeManagerMock!
    var viewModel: SearchJokeViewModel!
    
    override func setUp() {
        super.setUp()
        
        searchJokeManager = SearchJokeManagerMock()
        searchJokeManager.stubbedSearchResult = SignalProducer(value: Config.joke)
        
        viewModel = SearchJokeViewModel(searchJokeManager: searchJokeManager)
    }
    
    override func tearDown() {
        searchJokeManager = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testQueryUpdateTriggersSearchAndUpdatesResultOnSuccess() {
        // Trigger input query update
        viewModel.query.value = Config.query
        
        let expect = expectation(description: "debounce delay")
        DispatchQueue.main.asyncAfter(deadline: .now() + SearchJokeViewModel.Config.processInputQueryDelay) {
            expect.fulfill()
            
            // Search API was called
            XCTAssertTrue(self.searchJokeManager.invokedSearch)
            XCTAssertEqual(self.searchJokeManager.invokedSearchParameters?.query, Config.query)
            
            // Output matches expected
            XCTAssertEqual(self.viewModel.result.value, Config.joke.joke)
        }
        
        waitForExpectations(timeout: SearchJokeViewModel.Config.processInputQueryDelay * 2, handler: nil)
    }
    
    func testQueryUpdateTriggersSearchAndUpdatesResultOnFailure() {
        // Setup to return error on search attempt
        searchJokeManager.stubbedSearchResult = SignalProducer(error: SearchJokeManagerError.emptyData)
        
        // Trigger input query update
        viewModel.query.value = Config.query
        
        let expect = expectation(description: "debounce delay")
        DispatchQueue.main.asyncAfter(deadline: .now() + SearchJokeViewModel.Config.processInputQueryDelay) {
            expect.fulfill()
            
            // Search API was called
            XCTAssertTrue(self.searchJokeManager.invokedSearch)
            XCTAssertEqual(self.searchJokeManager.invokedSearchParameters?.query, Config.query)
            
            // Output matches expected
            XCTAssertEqual(self.viewModel.result.value, LocalizedString.notFound)
        }
        
        waitForExpectations(timeout: SearchJokeViewModel.Config.processInputQueryDelay * 2, handler: nil)
    }
}
