//
//  AppDetailAdultNoticeView.swift
//  
//
//  Created by ned on 10/02/23.
//

import SwiftUI

public struct AppDetailAdultNoticeView: View {
    
    public init() {}
    
    public var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "exclamationmark.lock")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("This content is **age-restricted**. If you are not legally allowed to view it, please leave this page **immediately**.")
                    .foregroundColor(.secondary)
            }
            .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct AppDetailAdultNoticeView_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailAdultNoticeView()
            .previewLayout(.sizeThatFits)
            .border(.red)
            .padding()
    }
}
