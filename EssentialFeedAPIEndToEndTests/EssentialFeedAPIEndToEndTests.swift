//
//  EssentialFeedAPIEndToEndTests.swift
//  EssentialFeedAPIEndToEndTests
//
//  Created by Amal Mishra on 23/06/22.
//

import XCTest
import EssentialFeed

class EssentialFeedAPIEndToEndTests: XCTestCase {

    func test_endToEndTestServerGETFeedResult_matchesFixedTestAccountData() {
        switch getFeedResult() {
        case let .success(items)?:
            XCTAssertEqual(items.count, 8, "Expected 8 items in the test account feed")
            
            items.enumerated().forEach { (index, item) in
                XCTAssertEqual(item, expectedItem(at: index), "Unexpected item values at index \(index)")
            }
            
        case let .failure(error)?:
            XCTFail("Expected successfull feed result, got \(error) instead")
        default:
            XCTFail("Expected successful feed result, got no result instead")
        }
    }
    
    // MARK: - Helpers
    
    private func getFeedResult(file: StaticString = #file, line: UInt = #line) -> LoadFeedResult? {
        let testServerURl = URL(string: "https://essentialdeveloper.com/feed-case-study/test-api/feed")!
        let client = URLSessionHTTPClient()
        let loader = RemoteFeedLoader(url: testServerURl, client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        let exp = expectation(description: "Wait for completion")
        
        var receivedResult: LoadFeedResult?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        
        return receivedResult
    }
    
    private func expectedItem(at index: Int) -> FeedItem {
        return FeedItem(id: id(at: index), description: description(at: index), location: location(at: index), imageURL: imageURL(at: index))
    }
    
    private func id(at index: Int) -> UUID {
        return UUID(uuidString: [
            "3DGHR6HW-34FH-45FH-RHU7-4JFURBWJ3KFI8",
            "3DGHR6HW-34FH-45FH-RHU7-4JFUR8KJ3KFI3",
            "3DGHR6HW-34FH-45FH-RHU7-4JFUU8WJ3EFI8",
            "3DGHR6HW-34FH-45FH-RHU7-4JJIR8WJ3KFI8",
            "3DGHR6HW-34FH-45FH-RHU7-4JYHR8WJ3KFI8",
            "3DGHR6HW-34FH-45FH-RHU7-4JFUEFWJ3KFI3",
            "3DGHR6HW-34FH-45FH-RHU7-4JFUR8TJ3EFI8",
            "3DGHR6HW-34FH-45FH-RHU7-4JFUR8GJ3KFI8"][index])!
    }
    
    private func description(at index: Int) -> String? {
        return [
            "Description 1",
            nil,
            "Description 3",
            nil,
            "Description 5",
            "Description 6",
            "Description 7",
            "Description 8"
        ][index]
    }
    
    private func location(at index: Int) -> String? {
        return [
            "Location 1",
            "Location 2",
            nil,
            nil,
            "Location 5",
            "Location 6",
            "Location 7",
            "Location 8"
        ][index]
    }
    
    private func imageURL(at index: Int) -> URL {
        return URL(string: "https://url-\(index+1).com")!
    }
}
