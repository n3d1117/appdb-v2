//
//  AppDetailTweakedVersionsView.swift
//  
//
//  Created by ned on 08/02/23.
//

import SwiftUI

public struct AppDetailTweakedVersionsView: View {
    
    let numberOfTweaks: Int
    let onTap: () -> Void
    
    public init(numberOfTweaks: Int, onTap: @escaping () -> Void) {
        self.numberOfTweaks = numberOfTweaks
        self.onTap = onTap
    }
    
    public var body: some View {
        let text = numberOfTweaks > 1 ? "\(numberOfTweaks) tweaks available" : "1 tweak available"
        
        RowButtonVStack(rowButtons: [
            RowButton(text: text, systemImage: "hammer") {
                onTap()
            }
        ])
    }
}

struct AppDetailTweakedVersionsView_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailTweakedVersionsView(numberOfTweaks: 3, onTap: {})
            .previewLayout(.sizeThatFits)
            .border(.red)
            .padding()
    }
}
