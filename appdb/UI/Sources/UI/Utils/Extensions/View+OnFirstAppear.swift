//
//  View+OnFirstAppear.swift
//  
//
//  Created by ned on 21/01/23.
//

import SwiftUI

private struct FirstAppear: ViewModifier {
    let action: () async -> Void
    
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        content.task {
            guard !hasAppeared else { return }
            hasAppeared = true
            await action()
        }
    }
}

public extension View {
    func onFirstAppear(_ action: @escaping () async -> Void) -> some View {
        modifier(FirstAppear(action: action))
    }
}
