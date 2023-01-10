//
//  AppDetailHeaderView.swift
//  
//
//  Created by ned on 10/01/23.
//

import SwiftUI
import NukeUI

public struct AppDetailHeaderView: View {
    
    let name: String
    let image: URL
    let category: String
    
    let size: CGSize = .init(width: 90, height: 90)
    
    public init(name: String, image: URL, category: String) {
        self.name = name
        self.image = image
        self.category = category
    }
    
    public var body: some View {
        HStack(alignment: .top) {
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
            
            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .font(.title2.leading(.tight))
                    .fontWeight(.medium)
                    .lineLimit(3)
                
                Text(category)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct AppDetailHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailHeaderView(
            name: "Discord - Chat, Talk & Hangout",
            image: .init(string: "https://is2-ssl.mzstatic.com/image/thumb/Purple113/v4/40/3f/c5/403fc5f0-7622-1171-5127-fae1666d3a84/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/100x100bb.jpg")!,
            category: "Social Networking"
        )
        .border(.red)
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
