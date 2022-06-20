//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Amal Mishra on 20/06/22.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
