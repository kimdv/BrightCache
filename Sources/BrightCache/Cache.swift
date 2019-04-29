//
//  Cache.swift
//  BrightCache
//
//  Created by Kim de Vos on 29/04/2019.
//  Copyright © 2019 Kim de Vos. All rights reserved.
//

import Foundation
import BrightFutures

protocol Cache {
    associatedtype Object

    func cache(_ object: Object) -> Future<Void, BrightCacheError>

    func fetchObject(for key: String) -> Future<Object, BrightCacheError>

    func removeObject(for key: String) -> Future<Void, BrightCacheError>

    func removeObject(_ object: Object) -> Future<Void, BrightCacheError>
}
