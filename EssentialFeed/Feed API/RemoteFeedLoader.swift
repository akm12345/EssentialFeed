//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Amal Mishra on 02/06/22.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadFeedResult<Error>
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    // default closure also passed to not break existing functions
    public func load(completion: @escaping (Result) -> Void) {
        //HTTPClient.shared.requestedUrl = URL(string: "url.com")
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(data, response):
                completion(FeedItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
