//
//  URL+Extensions.swift
//  appdb
//
//  Created by ned on 28/01/23.
//

import Foundation

extension URL {
    func iconHigherQuality(from pixelsBefore: Int = 100, to pixelsAfter: Int = 246) -> URL {
        .init(string: absoluteString.replacingOccurrences(
            of: "\(pixelsBefore)x\(pixelsBefore)bb.jpg",
            with: "\(pixelsAfter)x0w.webp" // webp is smaller in size!
        )) ?? self
    }
}
