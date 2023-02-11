//
//  AppDetailCopyrightView.swift
//  
//
//  Created by ned on 11/02/23.
//

import SwiftUI

public struct AppDetailCopyrightView: View {
    
    let publisher: String
    
    public init(publisher: String) {
        self.publisher = publisher
    }
    
    public var body: some View {
        Text("© \(publisher)")
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .font(.footnote)
            .foregroundColor(.secondary)
            .padding(.horizontal)
    }
}

struct AppDetailCopyrightView_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailCopyrightView(publisher: "Example")
    }
}
