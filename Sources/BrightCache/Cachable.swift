//
//  Cachable.swift
//  BrightCache
//
//  Created by Kim de Vos on 29/04/2019.
//  Copyright © 2019 Kim de Vos. All rights reserved.
//

import Foundation

public protocol Cachable: Codable {
    var cacheKey: String { get }
}
