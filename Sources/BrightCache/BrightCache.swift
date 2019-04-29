//
//  WatchItCache.swift
//  BrightCache
//
//  Created by Kim de Vos on 29/04/2019.
//  Copyright © 2019 Kim de Vos. All rights reserved.
//

import Foundation
import BrightFutures

final class BrightCache<Object: Cachable>: Cache {
    let diskCache: BrightDiskCache<Object>
    let memoryCache = BrightMemoryCache<Object>()

    init() throws {
        diskCache = try BrightDiskCache()
    }

    func cache(_ object: Object) -> Future<Void, BrightCacheError> {
        let memoryFuture = memoryCache.cache(object)
        let diskFuture = diskCache.cache(object)

        return memoryFuture.zip(diskFuture).asVoid()
    }

    func fetchObject(for key: String) -> Future<Object, BrightCacheError> {
        return memoryCache.fetchObject(for: key)
            .recoverWith { _ in self.diskCache.fetchObject(for: key) }
    }

    func removeObject(for key: String) -> Future<Void, BrightCacheError> {
        let memoryFuture = memoryCache.removeObject(for: key)
        let diskFuture = diskCache.removeObject(for: key)

        return memoryFuture.zip(diskFuture).asVoid()
    }

    func removeObject(_ object: Object) -> Future<Void, BrightCacheError> {
        return removeObject(for: object.cacheKey)
    }

}
