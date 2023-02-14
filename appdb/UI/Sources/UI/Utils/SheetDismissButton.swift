//
//  SheetDismissButton.swift
//  
//
//  Created by ned on 14/02/23.
//

import SwiftUI

public struct SheetDismissButton: View {
    @Environment(\.dismiss) private var dismiss
    
    public init() { }
        
    public var body: some View {
        Button {
            dismiss()
        } label: {
            Circle()
                .fill(Color.gray.opacity(0.25))
                .frame(width: 30, height: 30)
                .overlay(
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.secondary)
                )
        }
        .accessibilityLabel(Text(NSLocalizedString("Close", comment: "")))
    }
}

struct SheetDismissButton_Previews: PreviewProvider {
    static var previews: some View {
        SheetDismissButton()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
