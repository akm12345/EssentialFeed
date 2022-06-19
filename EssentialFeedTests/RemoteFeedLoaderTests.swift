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
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "urlTwo.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load {_ in }
        //XCTAssertNotNil(client.requestedURL)
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_requestsDataFromURLTwice() {
        let url = URL(string: "urlTwo.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load {_ in }
        sut.load {_ in }
        //XCTAssertNotNil(client.requestedURL)
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    /*
    func test_load_deliversErrorOnCleientError() {
        let (sut, client) = makeSUT()
        
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load {
            capturedErrors.append($0) }
        
        let clientError = NSError(domain: "Test", code: 0)
        
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
        
    }
     */
    
    // Modified version of above usin helper methods
    
    func test_load_deliversErrorOnCleientError() {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWIth: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HttpResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWIth: .failure(.invalidData), when: {
                client.complete(withStatusCode: code, at: index)
            })
            
            //XCTAssertEqual(capturedErrors, [.invalidData])
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWIth: .failure(.invalidData)) {
            let invalidJSON = Data(bytes: "invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyList() {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWIth: .success([])) {
            let emptyListJSON = Data(bytes: "{\"items\": []}".utf8)
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
    }
    
    func test_load_deliversItemsOn200HTTPRequestWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let item1 = FeedItem(id: UUID(), description: nil, location: nil, imageURL: URL(string: "http://a-url.com")!)
        let item1JSON = [
            "id": item1.id.uuidString,
            "image": item1.imageURL.absoluteString
        ]
        
        let item2 = FeedItem(id: UUID(), description: "a description", location: "a location", imageURL: URL(string: "http://another-url.com")!)
        let item2JSON = [
            "id": item2.id.uuidString,
            "description": item2.description,
            "location": item2.location,
            "image": item2.imageURL.absoluteString
        ]
        
        let itemsJSON = ["items": [item1JSON, item2JSON]]
        expect(sut, toCompleteWIth: .success([item1, item2])) {
            let json = try! JSONSerialization.data(withJSONObject: itemsJSON)
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    // MARK :- Helpers
    private func makeSUT(url: URL = URL(string: "test.com")!) -> (sut: RemoteFeedLoader, client: HttpClientSpy){
        let client = HttpClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWIth result: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load {
            capturedResults.append($0) }
        action()
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    // Remove singleton, use subclass
    private class HttpClientSpy: HTTPClient {
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0){
            //completions[index](error)
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index],
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
}
