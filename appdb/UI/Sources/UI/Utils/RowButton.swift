//
//  RowButton.swift
//  
//
//  Created by ned on 11/02/23.
//

import SwiftUI

public struct RowButton: View {
    
    let text: String
    let systemImage: String?
    let onTap: () -> Void
    
    let backgroundColor: Color
    let backgroundSelectedColor: Color
    
    public init(
        text: String,
        systemImage: String? = nil,
        backgroundColor: Color = Color.gray.opacity(0.15),
        backgroundSelectedColor: Color = Color.gray.opacity(0.25),
        onTap: @escaping () -> Void
    ) {
        self.text = text
        self.systemImage = systemImage
        self.backgroundColor = backgroundColor
        self.backgroundSelectedColor = backgroundSelectedColor
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
                    if let systemImage {
                        Image(systemName: systemImage)
                            .font(.subheadline)
                    }
                    Text(text)
                }
            }
            .font(.callout)
        }
        .buttonStyle(RowButtonStyle(backgroundColor: backgroundColor, backgroundSelectedColor: backgroundSelectedColor))
    }
}

private struct RowButtonStyle: ButtonStyle {
    
    let backgroundColor: Color
    let backgroundSelectedColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(configuration.isPressed ? backgroundSelectedColor : backgroundColor)
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


// MARK: RowButton VStack
extension RowButton: Equatable, Identifiable, Hashable {
    public static func == (lhs: RowButton, rhs: RowButton) -> Bool {
        lhs.text == rhs.text
    }
    
    public var id: String { text }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }
}

public struct RowButtonVStack: View {
    
    let rowButtons: [RowButton]
    
    public init(rowButtons: [RowButton]) {
        self.rowButtons = rowButtons
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(zip(rowButtons.indices, rowButtons)), id: \.1) { index, button in
                let roundMode = determineRoundMode(for: index)
                button
                    .cornerRadius(10, roundMode: roundMode)
                    .overlay(alignment: .top) {
                        if shouldShowDivider(for: roundMode) { Divider().padding(.leading) }
                    }
            }
        }
    }
    
    private func determineRoundMode(for index: Int) -> RoundMode {
        switch index {
        case 0:
            return rowButtons.count == 1 ? .all : .top
        default:
            return index != rowButtons.count - 1 ? .none : .bottom
        }
    }
    
    private func shouldShowDivider(for roundMode: RoundMode) -> Bool {
        [.none, .bottom].contains(roundMode)
    }
}

struct RowButtonVStack_Previews: PreviewProvider {
    static var previews: some View {
        RowButtonVStack(rowButtons: [
            .init(text: "test1", onTap: {}),
            .init(text: "test2", onTap: {}),
            .init(text: "test3", onTap: {}),
        ])
        .padding()
        .border(.red)
        .previewLayout(.sizeThatFits)
    }
}
