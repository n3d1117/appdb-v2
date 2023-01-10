//
//  AppGridView.swift
//  
//
//  Created by ned on 09/01/23.
//

import SwiftUI
import NukeUI

public struct AppGridView: View {
    private let size: CGSize = .init(width: 60, height: 60)
    
    let name: String
    let image: URL
    
    public init(name: String, image: URL) {
        self.name = name
        self.image = image
    }
    
    public var body: some View {
        VStack(spacing: 5) {
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
                .font(.footnote.leading(.tight))
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .frame(width: size.width, alignment: .leading)
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppGridView(name: "Example name", image: .init(string: "https://is2-ssl.mzstatic.com/image/thumb/Purple113/v4/40/3f/c5/403fc5f0-7622-1171-5127-fae1666d3a84/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/100x100bb.jpg")!)
    }
}
