//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Amal Mishra on 30/05/22.
//

import XCTest

class RemoteFeedLoader {
    func load() {
        //HTTPClient.shared.requestedUrl = URL(string: "url.com")
        HTTPClient.shared.get(from: URL(string: "url.com")!)
    }
}

class HTTPClient {
    //static let shared = HTTPClient()
    //private init() {}
    //var requestedURL: URL?
    
    // Remove singleton approach
    static var shared = HTTPClient()
    func get(from url: URL) {}
}

// Remove singleton, use subclass
class HttpClientSpy: HTTPClient {
    override func get(from url: URL) {
        requestedURL = url
    }
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromUrl() {
        let client = HttpClientSpy()
        HTTPClient.shared = client
        let _ = RemoteFeedLoader()
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HttpClientSpy()
        HTTPClient.shared = client
        let sut = RemoteFeedLoader()
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }
}
