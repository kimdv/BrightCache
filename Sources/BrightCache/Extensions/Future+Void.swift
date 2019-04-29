//
//  Future+Void.swift
//  BrightCache
//
//  Created by Kim de Vos on 29/04/2019.
//  Copyright © 2019 Kim de Vos. All rights reserved.
//

import BrightFutures

extension Future where Value.Value == Void {
    static func completed() -> Future<Void, Value.Error> {
        return Future(value: ())
    }
}
