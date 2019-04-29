//
//  BrightDiskCache.swift
//  BrightCache
//
//  Created by Kim de Vos on 29/04/2019.
//  Copyright © 2019 Kim de Vos. All rights reserved.
//

import Foundation
import BrightFutures

public final class BrightDiskCache<Object: Cachable>: Cache {
    let fileManager = FileManager.default

    let path: String

    private let queue = DispatchQueue(label: "io.kimdevos.BrightCache",
                                      qos: .userInitiated,
                                      attributes: .concurrent)

    public init() throws {
        path = try fileManager.url(for: .cachesDirectory,
                                   in: .userDomainMask,
                                   appropriateFor: nil,
                                   create: true)
            .appendingPathComponent("\(Object.self)", isDirectory: true).path

        try createDirectoryIfNeeded()
    }

    public func cache(_ object: Object) -> Future<Void, BrightCacheError> {
        let promise = Promise<Void, BrightCacheError>()

        queue.async {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(object)
                let path = self.createFilePath(for: object.cacheKey)

                if self.fileManager.createFile(atPath: path, contents: data, attributes: nil) {
                    promise.success()
                } else {
                    promise.failure(BrightCacheError.failedToWriteToDisk)
                }
            } catch {
                promise.failure(BrightCacheError.failedToEncode)
            }
        }

        return promise.future
    }

    public func fetchObject(for key: String) -> Future<Object, BrightCacheError> {
        let promise = Promise<Object, BrightCacheError>()

        queue.async {
            guard let data = self.fileManager.contents(atPath: self.createFilePath(for: key)) else {
                promise.failure(.objectNotFound)
                return
            }

            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(Object.self, from: data)

                promise.success(object)
            } catch {
                promise.failure(.failedToDecode)
            }
        }

        return promise.future
    }

    func fetchObjects() -> Future<[Object], BrightCacheError> {
        let promise = Promise<[Object], BrightCacheError>()

        queue.async {
            do {
                let decoder = JSONDecoder()
                let objects = try self.fileManager.contentsOfDirectory(atPath: self.path)
                    .map { self.path + "/" + $0 }
                    .compactMap(self.fileManager.contents)
                    .map { try decoder.decode(Object.self, from: $0) }
                promise.success(objects)
            } catch {
                promise.failure(.objectsNotFound)
            }
        }

        return promise.future
    }

    public func removeObject(for key: String) -> Future<Void, BrightCacheError> {
        let promise = Promise<Void, BrightCacheError>()

        queue.async {
            do {
                let path = self.createFilePath(for: key)
                try self.fileManager.removeItem(atPath: path)
                promise.success()
            } catch CocoaError.fileNoSuchFile {
                promise.success()
            } catch {
                promise.failure(.failedToRemoveFromCache)
            }
        }

        return promise.future
    }

    public func removeObject(_ object: Object) -> Future<Void, BrightCacheError> {
        return removeObject(for: object.cacheKey)
    }

    // MARK: - Helpers

    func createFilePath(for key: String) -> String {
        return path + "/" + createFileName(for: key)
    }

    func createFileName(for key: String) -> String {
        let fileExtension = URL(fileURLWithPath: key).pathExtension

        if fileExtension.isEmpty {
            return key.md5
        } else {
            return "\(key.md5).\(fileExtension)"
        }
    }

    // MARK: - Private

    private func createDirectoryIfNeeded() throws {
        guard !fileManager.fileExists(atPath: path) else { return }

        try fileManager.createDirectory(atPath: path,
                                        withIntermediateDirectories: true,
                                        attributes: nil)
    }

}
