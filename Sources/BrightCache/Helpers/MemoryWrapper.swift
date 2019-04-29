//
//  MemoryWrapper.swift
//  BrightCache
//
//  Created by Kim de Vos on 29/04/2019.
//  Copyright © 2019 Kim de Vos. All rights reserved.
//

import Foundation

final class MemoryWrapper: NSObject {
    let object: Any

    init(object: Any) {
        self.object = object
    }
}
