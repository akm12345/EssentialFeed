//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Amal Mishra on 30/05/22.
//

import Foundation

public enum LoadFeedResult<Error: Swift.Error> {
    case success ([FeedItem])
    case failure(Error)
}

extension LoadFeedResult: Equatable where Error: Equatable {}

protocol FeedLoader {
    associatedtype Error: Swift.Error
    func loadFeed(completion: @escaping(LoadFeedResult<Error>) -> Void)
}
