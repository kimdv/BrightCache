//
//  BrightDiskCacheTests.swift
//  BrightCacheTests-iOS
//
//  Created by Kim de Vos on 29/04/2019.
//  Copyright © 2019 Kim de Vos. All rights reserved.
//

import XCTest

@testable import BrightCache

final class BrightDiskCacheTests: XCTestCase {
    var cache: BrightDiskCache<User>!

    struct User: Cachable, Equatable {
        let cacheKey: String
        let name: String
    }

    override func setUp() {
        super.setUp()

        cache = try! BrightDiskCache<User>()
    }

    func testInitDiskCache() throws {
        XCTAssertTrue(FileManager.default.fileExists(atPath: cache.path))
    }

    func testMd5() {
        XCTAssertEqual("Kim".md5, "f55fbaaca148300ac11f7752528cae3d")
    }

    func testCreateFileNameWithExtension() {
        let fileName = "video.mp3"

        XCTAssertEqual(cache.createFileName(for: fileName), "e0b552ab5c8964fc0b6f2666add1e925.mp3")
    }

    func testCreateFileNameWithoutExtension() {
        let fileName = "video"

        XCTAssertEqual(cache.createFileName(for: fileName), "421b47ffd946ca083b65cd668c6b17e6")
    }

    func testCreateFilePathWithExtension() {
        let fileName = "video.mp3"
        let path = cache.createFilePath(for: fileName)

        XCTAssertEqual(cache.createFilePath(for: fileName), path)
    }

    func testCreateFilePathWithoutExtension() {
        let fileName = "video"
        let path = cache.createFilePath(for: fileName)

        XCTAssertEqual(cache.createFilePath(for: fileName), path)
    }

    func testCacheObject() throws {
        let object = User(cacheKey: "1", name: "Test 1")
        let result = cache.cache(object).forced()
        let path = cache.createFilePath(for: "1")

        XCTAssertTrue(FileManager.default.fileExists(atPath: path))
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
        let path = cache.createFilePath(for: "1")
        _ = cache.cache(object).forced()

        XCTAssertTrue(FileManager.default.fileExists(atPath: path))

        _ = cache.removeObject(for: "1").forced()

        XCTAssertFalse(FileManager.default.fileExists(atPath: path))
    }

    func testRemoveByObject() {
        let object = User(cacheKey: "1", name: "Test 1")
        let path = cache.createFilePath(for: "1")
        _ = cache.cache(object).forced()

        XCTAssertTrue(FileManager.default.fileExists(atPath: path))

        _ = cache.removeObject(object).forced()

        XCTAssertFalse(FileManager.default.fileExists(atPath: path))
    }

    func testRemoveNonExcitingObject() {
        let object = User(cacheKey: "1", name: "Test 1")
        let path = cache.createFilePath(for: "1")
        _ = cache.cache(object).forced()

        XCTAssertTrue(FileManager.default.fileExists(atPath: path))

        let result = cache.removeObject(for: "2").forced()

        XCTAssertNotNil(result.value)
        XCTAssertTrue(FileManager.default.fileExists(atPath: path))
    }

}
