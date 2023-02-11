//
//  AppDetailMoreByDeveloperView.swift
//  
//
//  Created by ned on 11/02/23.
//

import SwiftUI

public struct AppDetailMoreByDeveloperView: View {
    @ScaledMetric private var spacing: CGFloat = 8
    
    let developerName: String
    let developerWebsite: URL?
    let developerSupport: URL?
    let onDeveloperAppsTapped: () -> Void
    let onDeveloperWebsiteTapped: () -> Void
    let onDeveloperSupportTapped: () -> Void
    
    public init(developerName: String, developerWebsite: URL?, developerSupport: URL?, onDeveloperAppsTapped: @escaping () -> Void, onDeveloperWebsiteTapped: @escaping () -> Void, onDeveloperSupportTapped: @escaping () -> Void) {
        self.developerName = developerName
        self.developerWebsite = developerWebsite
        self.developerSupport = developerSupport
        self.onDeveloperAppsTapped = onDeveloperAppsTapped
        self.onDeveloperWebsiteTapped = onDeveloperWebsiteTapped
        self.onDeveloperSupportTapped = onDeveloperSupportTapped
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text("More by \(developerName)")
                .font(.title3)
                .fontWeight(.semibold)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(spacing: 5) {
                RowButton(text: "Developer Apps", systemImage: "circle.grid.3x3") {
                    onDeveloperAppsTapped()
                }
                if developerWebsite != nil {
                    RowButton(text: "Developer Website", systemImage: "globe") {
                        onDeveloperWebsiteTapped()
                    }
                }
                if developerSupport != nil {
                    RowButton(text: "Developer Support", systemImage: "questionmark.circle") {
                        onDeveloperSupportTapped()
                    }
                }
            }
        }
    }
}

struct AppDetailMoreByDeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailMoreByDeveloperView(developerName: "Example developer", developerWebsite: nil, developerSupport: nil, onDeveloperAppsTapped: {}, onDeveloperWebsiteTapped: {}, onDeveloperSupportTapped: {})
            .padding()
            .border(.red)
            .previewLayout(.sizeThatFits)
    }
}
