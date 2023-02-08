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
    let image: URL?
    let category: String
    
    let onImage: (UIImage?) -> Void
    let onCategoryTapped: () -> Void
    
    @ScaledMetric private var iconWidth: CGFloat = 120
    @ScaledMetric private var spacing: CGFloat = 15
    @ScaledMetric(relativeTo: .caption2) private var chevronSize: CGFloat = 9
    
    public init(name: String, image: URL?, category: String, onImage: @escaping (UIImage?) -> Void, onCategoryTapped: @escaping () -> Void) {
        self.name = name
        self.image = image
        self.category = category
        self.onImage = onImage
        self.onCategoryTapped = onCategoryTapped
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            LazyImage(url: image) { state in
                if let image = state.image {
                    image
                        .onFirstAppear { onImage(state.imageContainer?.image) }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .redacted(reason: .placeholder)
                }
            }
            .iconRounded(size: iconSize)
            
            VStack(alignment: .leading, spacing: 5) {
                Group {
                    Text(name)
                        .font(.title2.leading(.tight))
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    
                    Button {
                        onCategoryTapped()
                    } label: {
                        HStack(spacing: 2) {
                            Text(category)
                                .font(.subheadline)
                            Image(systemName: "chevron.right")
                                .font(.system(size: chevronSize))
                        }
                        .foregroundColor(.secondary)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                
                Spacer(minLength: 0)
                
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "icloud.and.arrow.down")
                            .font(.title3.weight(.semibold))
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title3.weight(.semibold))
                    }

                }
                .padding(.bottom, 1)

            }
            .frame(height: iconWidth)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var iconSize: CGSize {
        .init(width: iconWidth, height: iconWidth)
    }
}

struct AppDetailHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailHeaderView(
            name: "Discord - Chat, Talk & Hangout",
            image: .init(string: "https://is2-ssl.mzstatic.com/image/thumb/Purple113/v4/40/3f/c5/403fc5f0-7622-1171-5127-fae1666d3a84/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/100x100bb.jpg")!,
            category: "Social Networking",
            onImage: { _ in },
            onCategoryTapped: {}
        )
        .border(.red)
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
