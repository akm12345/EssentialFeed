//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Amal Mishra on 30/05/22.
//

import Foundation

public enum LoadFeedResult {
    case success ([FeedItem])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping(LoadFeedResult) -> Void)
}
