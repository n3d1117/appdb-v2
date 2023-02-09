//
//  SwiftUIView.swift
//  
//
//  Created by ned on 08/02/23.
//

import SwiftUI

public struct AppDetailTweakedVersionsView: View {
    
    let numberOfTweaks: Int
    let onTap: () -> Void
    
    public init(numberOfTweaks: Int, onTap: @escaping () -> Void) {
        self.numberOfTweaks = numberOfTweaks
        self.onTap = onTap
    }
    
    public var body: some View {
        Button {
            onTap()
        } label: {
            LabeledContent {
                Image(systemName: "chevron.right")
            } label: {
                HStack {
                    Image(systemName: "hammer")
                        .font(.subheadline)
                    if numberOfTweaks > 1 {
                        Text("\(numberOfTweaks) tweaks available")
                    } else {
                        Text("1 tweak available")
                    }
                }
            }
            .font(.callout)
        }
        .buttonStyle(AppDetailTweakedVersionsButtonStyle())
    }
}

private struct AppDetailTweakedVersionsButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(configuration.isPressed ? Color.gray.opacity(0.25) : Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct AppDetailTweakedVersionsView_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailTweakedVersionsView(numberOfTweaks: 3, onTap: {})
            .previewLayout(.sizeThatFits)
            .border(.red)
            .padding()
    }
}
