//
//  AppDetailWhatsNew.swift
//  
//
//  Created by ned on 17/01/23.
//

import SwiftUI

public struct AppDetailWhatsNew: View {
    
    @ScaledMetric private var spacing: CGFloat = 8
    
    let text: String
    let version: String
    let updatedDate: Date
    
    public init(text: String, version: String, updatedDate: Date) {
        self.text = text
        self.version = version
        self.updatedDate = updatedDate
    }
    
    public var body: some View {
        VStack(spacing: spacing) {
            HStack(alignment: .lastTextBaseline) {
                Text("What's New")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("v\(version)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(updatedDate.formatted(.relative(presentation: .numeric)))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            ExpandableText(text)
        }
    }
}

struct AppDetailWhatsNew_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AppDetailWhatsNew(text: """
- Get more editing inspirations in "Find ideas"
- Bug fixes and other improvements

Email us at inshot.ios@inshot.com. Your ideas and feedback are important to us!
""", version: "1.2.3", updatedDate: .now.addingTimeInterval(-15000))
                    .border(.red)
                    .padding()
                Spacer()
            }
        }
    }
}
