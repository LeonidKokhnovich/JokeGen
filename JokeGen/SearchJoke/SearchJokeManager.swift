//
//  SearchJokeEngine.swift
//  JokeGen
//
//  Created by Leonid Kokhnovych on 2018-05-10.
//  Copyright © 2018 Leonid Kokhnovych. All rights reserved.
//

import Foundation

protocol SearchJokeManagerType {
    func search(by query: String)
}

class SearchJokeManager: SearchJokeManagerType {
    func search(by query: String) {
        let query = SearchJokeQuery()
        apollo.fetch(query: query) { [weak self] (result, error) in
            guard error == nil else {
                print("Failed request with error: \(error?.localizedDescription)")
                return
            }
            
            guard let joke = result?.data else {
                print("No joke found: \(result.debugDescription)")
                return
            }
            
            
            //            result?.data?.j
            print("Joke: \(joke)")
        }
    }
}
