//
//  AppDetailMiniIconView.swift
//  
//
//  Created by ned on 28/01/23.
//

import SwiftUI
import NukeUI

public struct AppDetailMiniIconView: View {
    let image: URL
    
    private let iconWidth: CGFloat = 28
    
    public init(image: URL) {
        self.image = image
    }
    
    public var body: some View {
        LazyImage(url: image) { state in
            if let image = state.image {
                image
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .redacted(reason: .placeholder)
            }
        }
        .iconRounded(size: iconSize)
    }
    
    private var iconSize: CGSize {
        .init(width: iconWidth, height: iconWidth)
    }
}

struct AppDetailMiniIconView_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailMiniIconView(image: .init(string: "https://is5-ssl.mzstatic.com/image/thumb/Purple113/v4/55/27/59/552759dc-67c4-506a-0f66-f09228caf59d/AppIcon_TikTok-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/100x100bb.jpg")!)
    }
}
