//
//  CornerRadiusStyle.swift
//  
//
//  Created by ned on 12/02/23.
//

import SwiftUI

private struct CornerRadiusStyle: ViewModifier {
    let roundMode: RoundMode
    let radius: CGFloat
    
    func body(content: Content) -> some View {
        switch roundMode {
        case .all:
            content
                .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
        case .top:
            content
                .padding(.bottom, radius)
                .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                .padding(.bottom, -radius)
        case .bottom:
            content
                .padding(.top, radius)
                .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
                .padding(.top, -radius)
        case .none:
            content
        }
    }
}

public enum RoundMode {
    case none, top, bottom, all
}

public extension View {
    func cornerRadius(_ radius: CGFloat, roundMode: RoundMode) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(roundMode: roundMode, radius: radius))
    }
}

struct CornerRadiusStyleView_Previews: PreviewProvider {
    static var previews: some View {
        Text("testing")
            .padding()
            .background(.blue)
            .cornerRadius(10, roundMode: .bottom)
    }
}
