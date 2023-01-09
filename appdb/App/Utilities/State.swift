//
//  State.swift
//  appdb-v2
//
//  Created by ned on 09/01/23.
//

import Foundation

enum State<T: Equatable>: Equatable {
    case success(T)
    case failed(Error)
    case loading
    
    static func ==(lhs: State, rhs: State) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case let (.success(lhsValue), .success(rhsValue)):
            return lhsValue == rhsValue
        case let (.failed(lhsError), .failed(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
