//
//  CGError+Assert.swift
//  ThinkpadAssistant
//
//  Created by Matt on 20.04.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import CoreGraphics

extension CGError {
    
    func require() -> CGError {
        assert(self == .success, "reason: \(self)")
        return self
    }
    
    func handleError() {
        assert(self == .success, "reason: \(self)")
    }
}
