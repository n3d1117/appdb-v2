//
//  AppDetailDescription.swift
//  
//
//  Created by ned on 17/01/23.
//

import SwiftUI

public struct AppDetailDescription: View {
    let text: String
    
    public init(text: String) {
        self.text = text
    }

    public var body: some View {
        ExpandableText(text)
    }
}

struct AppDetailDescription_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AppDetailDescription(text: """
This update includes:
- minor bug fixes

See in-game notices for details
""")
                    .border(.red)
                    .padding()
                Spacer()
            }
        }
    }
}
