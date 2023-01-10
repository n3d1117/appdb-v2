//
//  AppListView.swift
//  
//
//  Created by ned on 09/01/23.
//

import SwiftUI
import NukeUI

public struct AppListView: View {
    private let size: CGSize = .init(width: 45, height: 45)
    
    let name: String
    let image: URL
    
    public init(name: String, image: URL) {
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
        AppListView(name: "Example name", image: .init(string: "https://is2-ssl.mzstatic.com/image/thumb/Purple113/v4/40/3f/c5/403fc5f0-7622-1171-5127-fae1666d3a84/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/100x100bb.jpg")!)
            .border(.red)
            .previewLayout(.sizeThatFits)
    }
}
