//
//  BrightMemoryCache.swift
//  BrightCache
//
//  Created by Kim de Vos on 29/04/2019.
//  Copyright © 2019 Kim de Vos. All rights reserved.
//

import Foundation
import BrightFutures

public final class BrightMemoryCache<Object: Cachable>: Cache {
    private let memoryCache = NSCache<NSString, MemoryWrapper>()

    public func cache(_ object: Object) -> Future<Void, BrightCacheError> {
        memoryCache.setObject(MemoryWrapper(object: object), forKey: object.cacheKey as NSString)
        return Future.completed()
    }

    public func fetchObject(for key: String) -> Future<Object, BrightCacheError> {
        guard let object = memoryCache.object(forKey: key as NSString)?.object as? Object
            else { return Future(error: .objectNotFound) }

        return Future(value: object)
    }

    public func removeObject(for key: String) -> Future<Void, BrightCacheError> {
        memoryCache.removeObject(forKey: key as NSString)
        return Future.completed()
    }

    public func removeObject(_ object: Object) -> Future<Void, BrightCacheError> {
        return removeObject(for: object.cacheKey)
    }
}
