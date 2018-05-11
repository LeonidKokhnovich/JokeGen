//
//  SearchJokeEngine.swift
//  JokeGen
//
//  Created by Leonid Kokhnovych on 2018-05-10.
//  Copyright © 2018 Leonid Kokhnovych. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol SearchJokeManagerType {
    func search(by query: String) -> SignalProducer<SearchJokeQuery.Data.Joke, SearchJokeManagerError>
}

enum SearchJokeManagerError: Error, LocalizedError {
    case query(Error)
    case emptyData
    
    var localizedDescription: String {
        switch self {
        case .emptyData:
            return LocalizedString.notFound
        case .query(let error):
            return error.localizedDescription
        }
    }
}

class SearchJokeManager: SearchJokeManagerType {
    // To simplify the project and not have dependency injection library, let's use singleton for injection.
    static let shared = SearchJokeManager()
    
    func search(by query: String) -> SignalProducer<SearchJokeQuery.Data.Joke, SearchJokeManagerError> {
        return SignalProducer { observer, disposable in
            print("Query joke by: \(query)")
            
            let query = SearchJokeQuery(query: query)
            let cancellable = apollo.fetch(query: query) { (result, error) in
                if let error = error {
                    print("Failed request with error: \(error.localizedDescription)")
                    observer.send(error: .query(error))
                    return
                }
                
                guard let joke = result?.data?.joke else {
                    print("No joke found: \(result.debugDescription)")
                    observer.send(error: .emptyData)
                    return
                }
                
                print("Retrieved joke: \(joke)")
                
                observer.send(value: joke)
                observer.sendCompleted()
            }
            
            // Cancel the query if it's not needed anymore...
            disposable.observeEnded({
                cancellable.cancel()
            })
        }
    }
}
