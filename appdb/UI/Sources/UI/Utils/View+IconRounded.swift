//
//  View+IconRounded.swift
//  
//
//  Created by ned on 28/01/23.
//

import SwiftUI

private struct IconRounded: ViewModifier {
    let size: CGSize
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: size.width / 4.2, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: size.width / 4.2).stroke(.gray.opacity(0.15)))
            .scaledToFit()
            .frame(width: size.width, height: size.height)
    }
}

public extension View {
    func iconRounded(size: CGSize) -> some View {
        modifier(IconRounded(size: size))
    }
}
