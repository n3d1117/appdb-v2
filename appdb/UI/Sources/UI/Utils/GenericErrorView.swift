//
//  GenericErrorView.swift
//  
//
//  Created by ned on 09/01/23.
//

import SwiftUI

public struct GenericErrorView: View {
    let title: String
    let error: String
    let onRetry: (() async -> Void)?
    
    public init(title: String = "An error has occurred", error: String, onRetry: (() async -> Void)? = nil) {
        self.title = title
        self.error = error
        self.onRetry = onRetry
    }

    public var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Text(error)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 280)
                .padding(.bottom, 10)

            if let onRetry {
                Button {
                    Task {
                        await onRetry()
                    }
                } label: {
                    Label("Retry", systemImage: "arrow.clockwise")
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

struct GenericErrorView_Previews: PreviewProvider {
    static var previews: some View {
        GenericErrorView(error: "Example error", onRetry: {})
    }
}
