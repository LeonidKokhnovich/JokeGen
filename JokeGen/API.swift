//  This file was automatically generated and should not be edited.

import Apollo

public final class SearchJokeQuery: GraphQLQuery {
  public static let operationString =
    "query SearchJoke($query: String) {\n  joke(query: $query) {\n    __typename\n    joke\n  }\n}"

  public var query: String?

  public init(query: String? = nil) {
    self.query = query
  }

  public var variables: GraphQLMap? {
    return ["query": query]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("joke", arguments: ["query": GraphQLVariable("query")], type: .object(Joke.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(joke: Joke? = nil) {
      self.init(snapshot: ["__typename": "Query", "joke": joke.flatMap { (value: Joke) -> Snapshot in value.snapshot }])
    }

    public var joke: Joke? {
      get {
        return (snapshot["joke"] as? Snapshot).flatMap { Joke(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "joke")
      }
    }

    public struct Joke: GraphQLSelectionSet {
      public static let possibleTypes = ["Joke"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("joke", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(joke: String? = nil) {
        self.init(snapshot: ["__typename": "Joke", "joke": joke])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var joke: String? {
        get {
          return snapshot["joke"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "joke")
        }
      }
    }
  }
}