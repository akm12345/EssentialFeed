//
//  XCTestCase+MemoryLeakTrackHelper.swift
//  EssentialFeedTests
//
//  Created by Amal Mishra on 22/06/22.
//

import Foundation
import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been dealocated. Potential memory leak.", file: file, line: line)
        }
    }
}
