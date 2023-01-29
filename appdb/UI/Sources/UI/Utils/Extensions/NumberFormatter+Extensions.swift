//
//  NumberFormatter+Extensions.swift
//  
//
//  Created by ned on 29/01/23.
//

import Foundation

extension NumberFormatter {
    static let ratingsNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .floor
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        return formatter
    }()
}
