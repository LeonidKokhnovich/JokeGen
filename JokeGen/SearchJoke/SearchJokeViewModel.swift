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
    var query = MutableProperty<String?>(nil)
    
    var result: Property<String>
    // Make mutable property so it's not updated outside of the view model.
    private var mutableResult = MutableProperty<String>("")
    
    init() {
        result = Property(mutableResult)
        
        query.producer.map { $0 ?? "" }.startWithValues { [weak self] (query) in
            guard let strongSelf = self else { return }
            strongSelf.mutableResult.value = query + query
        }
    }
}
