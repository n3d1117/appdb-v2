//
//  AppDetailCompatibilityView.swift
//  
//
//  Created by ned on 28/01/23.
//

import SwiftUI

public struct AppDetailCompatibilityView: View {
    let compatibilityString: String
    
    let compatibilityList: String?
    let versionRequirement: String?

    public init(compatibilityString: String) {
        self.compatibilityString = compatibilityString
        
        self.compatibilityList = compatibilityString.components(separatedBy: ". ").first
        self.versionRequirement = compatibilityString.components(separatedBy: ". ").dropFirst().first
    }
    
    public var body: some View {
        HStack(spacing: 15) {
            HStack(spacing: 3) {
                if compatibilityString.contains("iPhone") {
                    Image(systemName: "iphone")
                }
                if compatibilityString.contains("iPad") {
                    Image(systemName: "ipad")
                }
            }
            .font(.body)
            
            Group {
                if let compatibilityList, let versionRequirement {
                    Text(compatibilityList) + Text("\n") + Text(versionRequirement)
                } else {
                    Text(compatibilityString)
                }
            }
            .font(.footnote)
        }
        .foregroundColor(.secondary)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct AppDetailCompatibilityView_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailCompatibilityView(compatibilityString: "Compatible with iPhone, iPad, iPod. Requires iOS 10.0 or newer")
            .previewLayout(.sizeThatFits)
    }
}
