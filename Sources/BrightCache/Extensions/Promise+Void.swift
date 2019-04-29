//
//  Promise+Void.swift
//  BrightCache
//
//  Created by Kim de Vos on 29/04/2019.
//  Copyright © 2019 Kim de Vos. All rights reserved.
//

import BrightFutures

extension Promise where T == Void {
    func success() {
        self.success(())
    }
}
