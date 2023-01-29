//
//  FittingScrollView.swift
//  
//
//  Created by ned on 28/01/23.
//

import SwiftUI

/// Source: https://github.com/shaps80/SwiftUIBackports
/// A scrollview that behaves more similarly to a `VStack` when its content size is small enough.
public struct FittingScrollView<Content: View>: View {
    private let content: Content
    let onOffsetChange: (CGFloat) -> Void

    public init(@ViewBuilder content: () -> Content, onOffsetChange: @escaping (CGFloat) -> Void) {
        self.content = content()
        self.onOffsetChange = onOffsetChange
    }

    public var body: some View {
        GeometryReader { geo in
            ScrollViewOffset(onOffsetChange: onOffsetChange) {
                VStack {
                    content
                }.frame(maxWidth: geo.size.width, minHeight: geo.size.height)
            }
        }
    }
}
