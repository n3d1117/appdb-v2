//
//  Font+Extensions.swift
//  
//
//  Created by ned on 21/01/23.
//

import SwiftUI

extension Font {
    init(uiFont: UIFont) {
        self = Font(uiFont as CTFont)
    }
}
