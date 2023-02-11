//
//  AppDetailTweakedNoticeView.swift
//  
//
//  Created by ned on 04/02/23.
//

import SwiftUI

public struct AppDetailTweakedNoticeView: View {
    
    let onSeeOriginalTapped: () -> Void
    
    public init(onSeeOriginalTapped: @escaping () -> Void) {
        self.onSeeOriginalTapped = onSeeOriginalTapped
    }
    
    public var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title3)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("This app was **tweaked** to provide additional features. To ensure it is safe from malicious code, download it from **verified** crackers only.")
                    .foregroundColor(.secondary)
                
                Button {
                    onSeeOriginalTapped()
                } label: {
                    HStack(alignment: .lastTextBaseline, spacing: 2) {
                        Text("See original app")
                        Image(systemName: "chevron.right")
                            .font(.caption2)
                    }
                }

            }
            .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct AppDetailTweakedNoticeView_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailTweakedNoticeView(onSeeOriginalTapped: {})
            .previewLayout(.sizeThatFits)
            .border(.red)
            .padding()
    }
}
