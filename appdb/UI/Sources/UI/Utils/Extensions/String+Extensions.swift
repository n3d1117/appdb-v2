//
//  String+Extensions.swift
//  
//
//  Created by ned on 21/01/23.
//

import UIKit

extension String {
    func size(using font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = size(withAttributes: fontAttributes)
        return size
    }
}
