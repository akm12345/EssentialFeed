//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Amal Mishra on 02/06/22.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error) -> Void)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    public enum Error: Swift.Error {
        case connectivity
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    // default closure also passed to not break existing functions
    public func load(completion: @escaping (Error) -> Void) {
        //HTTPClient.shared.requestedUrl = URL(string: "url.com")
        client.get(from: url) { error in
            completion(.connectivity)
        }
    }
}
