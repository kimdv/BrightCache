//
//  BrightMemoryCacheTests.swift
//  BrightCacheTests-iOS
//
//  Created by Kim de Vos on 29/04/2019.
//  Copyright © 2019 Kim de Vos. All rights reserved.
//

import XCTest
@testable import BrightCache

final class BrightMemoryCacheTests: XCTestCase {
    var cache: BrightMemoryCache<User>!

    struct User: Cachable, Equatable {
        let cacheKey: String
        let name: String
    }

    override func setUp() {
        super.setUp()

        cache = BrightMemoryCache<User>()
    }

    func testCacheObject() throws {
        let object = User(cacheKey: "1", name: "Test 1")
        let result = cache.cache(object).forced()
        let cachedObject = cache.fetchObject(for: "1").forced().value

        XCTAssertEqual(cachedObject, object)
        XCTAssertNil(result.error)
        XCTAssertNotNil(result.value)
    }

    func testFetchObject() {
        let object = User(cacheKey: "1", name: "Test 1")
        _ = cache.cache(object).forced()
        let result = cache.fetchObject(for: "1").forced()

        XCTAssertNil(result.error)
        XCTAssertEqual(result.value, object)
    }

    func testRemoveByKey() {
        let object = User(cacheKey: "1", name: "Test 1")
        _ = cache.cache(object).forced().value
        let cachedObject = cache.fetchObject(for: "1").forced().value

        XCTAssertEqual(object, cachedObject)

        _ = cache.removeObject(for: "1").forced()
        let nonCachedObject = cache.fetchObject(for: "1")

        XCTAssertNil(nonCachedObject.value)
        XCTAssertEqual(nonCachedObject.error, .objectNotFound)
    }

    func testRemoveByObject() {
        let object = User(cacheKey: "1", name: "Test 1")
        _ = cache.cache(object).forced().value
        let cachedObject = cache.fetchObject(for: "1").forced().value

        XCTAssertEqual(object, cachedObject)

        _ = cache.removeObject(for: "1").forced()
        let nonCachedObject = cache.fetchObject(for: "1")

        XCTAssertNil(nonCachedObject.value)
        XCTAssertEqual(nonCachedObject.error, .objectNotFound)
    }

    func testRemoveNonExcitingObject() {
        let object = User(cacheKey: "1", name: "Test 1")
        _ = cache.cache(object).forced().value
        let cachedObject = cache.fetchObject(for: "1").forced().value

        XCTAssertEqual(object, cachedObject)

        let nonCachedObject = cache.removeObject(for: "2").forced()

        XCTAssertNotNil(nonCachedObject.value)
    }

}
