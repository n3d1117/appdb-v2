//
//  RowButton.swift
//  
//
//  Created by ned on 11/02/23.
//

import SwiftUI

struct RowButton: View {
    
    let text: String
    let systemImage: String?
    let onTap: () -> Void
    
    public init(text: String, systemImage: String? = nil, onTap: @escaping () -> Void) {
        self.text = text
        self.systemImage = systemImage
        self.onTap = onTap
    }
    
    var body: some View {
        Button {
            onTap()
        } label: {
            LabeledContent {
                Image(systemName: "chevron.right")
            } label: {
                HStack {
                    if let systemImage {
                        Image(systemName: systemImage)
                            .font(.subheadline)
                    }
                    Text(text)
                }
            }
            .font(.callout)
        }
        .buttonStyle(RowButtonStyle())
    }
}

private struct RowButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(configuration.isPressed ? Color.gray.opacity(0.25) : Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct RowButton_Previews: PreviewProvider {
    static var previews: some View {
        RowButton(text: "Example CTA", systemImage: "hammer", onTap: {})
            .padding()
            .border(.red)
            .previewLayout(.sizeThatFits)
    }
}
