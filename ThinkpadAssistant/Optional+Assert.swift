//
//  Optional+Assert.swift
//  ThinkpadAssistant
//
//  Created by Matt on 20.04.20.
//  Copyright © 2020 Matthäus Szturc. All rights reserved.
//

import Foundation

extension Optional {
    func assert(or defaultValue: Wrapped) -> Wrapped {
        switch self {
        case .none:
            assertionFailure()
            return defaultValue
        case .some(let value):
            return value
        }
    }

    // TODO: check with and without "rethrows"
    func assertExecute(_ action: (Wrapped) throws -> Void) rethrows {
        switch self {
        case .none:
            assertionFailure()
        case .some(let value):
            try action(value)
        }
    }
}
