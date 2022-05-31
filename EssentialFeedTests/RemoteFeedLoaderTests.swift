//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Amal Mishra on 30/05/22.
//

import XCTest

class RemoteFeedLoader {
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    let url: URL
    private var client: HTTPClient
    
    func load() {
        //HTTPClient.shared.requestedUrl = URL(string: "url.com")
        client.get(from: url)
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
        let _ = RemoteFeedLoader(url: URL(string: "urlOne.com")!, client: client)
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "urlTwo.com")!
        let client = HttpClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        sut.load()
        //XCTAssertNotNil(client.requestedURL)
        XCTAssertEqual(client.requestedURL, url)
    }
}
