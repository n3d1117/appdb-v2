//
//  AppListView.swift
//  
//
//  Created by ned on 09/01/23.
//

import SwiftUI
import NukeUI

public struct AppListView: View {
    
    let name: String
    let image: URL?
    
    let size: CGSize = .init(width: 45, height: 45)
    
    public init(name: String, image: URL? = nil) {
        self.name = name
        self.image = image
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            LazyImage(url: image) { state in
                if let image = state.image {
                    image
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .redacted(reason: .placeholder)
                }
            }
            .processors([.resize(size: size)])
            .clipShape(RoundedRectangle(cornerRadius: size.width / 4.2, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: size.width / 4.2).stroke(.gray.opacity(0.15)))
            .frame(width: size.width, height: size.height)
                        
            Text(name)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity)
    }
}

struct AppListView_Previews: PreviewProvider {
    static var previews: some View {
        AppListView(name: "Example name", image: .init(string: "https://edoardo.fyi/me.jpeg")!)
            .border(.red)
            .previewLayout(.sizeThatFits)
    }
}
