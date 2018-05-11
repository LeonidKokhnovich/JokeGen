//
//  SearchJokeViewModel.swift
//  JokeGen
//
//  Created by Leonid Kokhnovych on 2018-05-10.
//  Copyright © 2018 Leonid Kokhnovych. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol SearchJokeViewModelType {
    var query: MutableProperty<String?> { get }
    var result: Property<String> { get }
}

class SearchJokeViewModel: SearchJokeViewModelType {
    struct Config {
        static let inputQueryThrottleTiming = 1.0
    }
    
    var query = MutableProperty<String?>(nil)
    var result: Property<String>
    // Make mutable property so it's not updated outside of the view model.
    private var mutableResult = MutableProperty<String>("")
    
    private let searchJokeManager: SearchJokeManagerType
    
    init(searchJokeManager: SearchJokeManagerType = SearchJokeManager.shared) {
        self.searchJokeManager = searchJokeManager
        result = Property(mutableResult)
        
        observeQueryUpdates()
    }
    
    func observeQueryUpdates() {
        query.producer
            .throttle(Config.inputQueryThrottleTiming, on: QueueScheduler.main)
            .map { $0 ?? "" }
            .startWithValues { [weak self] (query) in
                guard let strongSelf = self else {
                    print("Invalid self")
                    return
                }
                
                strongSelf.updateResult(by: query)
        }
    }
    
    func updateResult(by query: String) {
        searchJokeManager.search(by: query)
            .observe(on: UIScheduler())
            .startWithResult { [weak self] (result) in
                guard let strongSelf = self else {
                    print("Invalid self")
                    return
                }
                
                switch result {
                case .failure(let error):
                    strongSelf.mutableResult.value = error.localizedDescription
                case .success(let joke):
                    strongSelf.mutableResult.value = joke.joke ?? "Not found"
                }
        }
    }
}
