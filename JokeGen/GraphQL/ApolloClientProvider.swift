//
//  ApolloClientProvider.swift
//  JokeGen
//
//  Created by Leonid Kokhnovych on 2018-05-10.
//  Copyright © 2018 Leonid Kokhnovych. All rights reserved.
//

import Foundation
import Apollo

protocol ApolloClientProviderType {
    var apollo: ApolloClient { get }
}

class ApolloClientProvider: ApolloClientProviderType {
    struct Config {
        static let graphQLEndpoint = "https://icanhazdadjoke.com/graphql"
    }
    
    // To simplify the project and not have dependency injection library, let's use singleton for injection.
    static let shared = ApolloClientProvider()
    
    let apollo: ApolloClient
    
    init() {
        guard let url = URL(string: Config.graphQLEndpoint) else {
            fatalError("Invalid graphQLEndpoint URL")
        }
        
        apollo = ApolloClient(url: url)
    }
}
