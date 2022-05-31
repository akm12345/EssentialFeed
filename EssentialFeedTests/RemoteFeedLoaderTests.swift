//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Amal Mishra on 30/05/22.
//

import XCTest

class RemoteFeedLoader {
    init(client: HTTPClient) {
        self.client = client
    }
    
    private var client: HTTPClient
    
    func load() {
        //HTTPClient.shared.requestedUrl = URL(string: "url.com")
        client.get(from: URL(string: "url.com")!)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

// Remove singleton, use subclass
class HttpClientSpy: HTTPClient {
    func get(from url: URL) {
        requestedURL = url
    }
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromUrl() {
        let client = HttpClientSpy()
        let _ = RemoteFeedLoader(client: client)
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HttpClientSpy()
        let sut = RemoteFeedLoader(client: client)
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }
}
