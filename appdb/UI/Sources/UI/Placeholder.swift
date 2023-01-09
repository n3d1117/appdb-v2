//
//  Placeholder.swift
//  
//
//  Created by ned on 09/01/23.
//

import SwiftUI
import Shimmer

struct Placeholder: ViewModifier {
    func body(content: Content) -> some View {
        content
            .redacted(reason: .placeholder)
            .shimmering()
    }
}

public extension View {
    func placeholder() -> some View {
        modifier(Placeholder())
    }
}


