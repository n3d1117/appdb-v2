//
//  AppDetailScreenshots.swift
//  
//
//  Created by ned on 11/01/23.
//

import SwiftUI
import NukeUI

public struct AppDetailScreenshots: View {
    
    public static let preferredWidth: (portrait: CGFloat, landscape: CGFloat) = (180, 280)
    public static let maxHeight: CGFloat = 400
    
    public typealias Screenshot = (url: URL, size: CGSize)
    let screenshots: [Screenshot]
    
    public init(screenshots: [Screenshot]) {
        self.screenshots = screenshots
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(screenshots, id: \.url.hashValue) { screenshot in
                    let shouldRotate = mixedClasses && isLandscape(screenshot)
                    
                    LazyImage(url: screenshot.url) { state in
                        if let image = state.image {
                            image
                                .resizingMode(.aspectFit)
                                .rotationEffect(shouldRotate ? .degrees(-90) : .zero)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .redacted(reason: .placeholder)
                        }
                    }
                    .processors([.resize(width: screenshot.size.width)])
                    .modifier(RotationHandler(shouldRotate: shouldRotate, size: screenshot.size))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(.gray.opacity(0.15)))
                }
            }
            .padding(.horizontal)
            .scrollViewContentRTLFriendly()
        }
        .frame(height: screenshots.map(\.size.height).max() ?? Self.maxHeight)
        .scrollViewRTLFriendly()
    }
    
    private var mixedClasses: Bool {
        let landscapeCount = screenshots.filter({ isLandscape($0) }).count
        let portraitCount = screenshots.count - landscapeCount
        return landscapeCount > .zero && portraitCount > .zero
    }
    
    private func isLandscape(_ screenshot: Screenshot) -> Bool {
        screenshot.size.width > screenshot.size.height
    }
}

private struct RotationHandler: ViewModifier {
    
    let shouldRotate: Bool
    let size: CGSize
    
    func body(content: Content) -> some View {
        if shouldRotate {
            let preferredWidth: CGFloat = AppDetailScreenshots.preferredWidth.portrait
            let preferredHeight: CGFloat = size.width/size.height * preferredWidth
            content
                .frame(width: preferredHeight, height: preferredHeight)
                .scaledToFit()
                .frame(width: preferredWidth, height: preferredHeight)
        } else {
            content
                .frame(width: size.width, height: size.height)
        }
    }
}

struct AppDetailScreenshots_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailScreenshots(screenshots: [
            (url: .init(string:  "https://is5-ssl.mzstatic.com/image/thumb/PurpleSource125/v4/90/4b/56/904b56a5-54c8-3d59-d520-3d8ab54d3aac/dd0a6861-381f-47c8-8efe-b4fb695dd2b3_iPhone-8-Plus-Shot02.png/392x696bb.png")!, size: .init(width: 180, height: 320)),
            (url: .init(string:  "https://is3-ssl.mzstatic.com/image/thumb/Purple116/v4/40/de/db/40dedb1b-af8d-e95d-9588-98876a9e4c54/3c745005-cb54-4f02-956d-77a44b8f1c43_en8.png/406x228bb.png")!, size: .init(width: 280, height: 158)),
            (url: .init(string:  "https://is5-ssl.mzstatic.com/image/thumb/PurpleSource125/v4/90/4b/56/904b56a5-54c8-3d59-d520-3d8ab54d3aac/dd0a6861-381f-47c8-8efe-b4fb695dd2b3_iPhone-8-Plus-Shot02.png/392x696bb.png")!, size: .init(width: 180, height: 320)),
        ])
        .border(.blue)
    }
}
