//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Amal Mishra on 30/05/22.
//

import Foundation

enum LoadFeedResult {
    case success ([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func loadFeed(completion: @escaping(LoadFeedResult) -> Void)
}
