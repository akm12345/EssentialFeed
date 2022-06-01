//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Amal Mishra on 30/05/22.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromUrl() {
        let (_, client) = makeSUT()
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "urlTwo.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load()
        //XCTAssertNotNil(client.requestedURL)
        XCTAssertEqual(client.requestedURL, url)
    }
    
    // MARK :- Helpers
    private func makeSUT(url: URL = URL(string: "test.com")!) -> (sut: RemoteFeedLoader, client: HttpClientSpy){
        let client = HttpClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    // Remove singleton, use subclass
    private class HttpClientSpy: HTTPClient {
        var requestedURL: URL?
        
        func get(from url: URL) {
            requestedURL = url
        }
    }
}
