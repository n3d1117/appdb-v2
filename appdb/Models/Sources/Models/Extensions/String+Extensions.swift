//
//  String+Extensions.swift
//  
//
//  Created by ned on 18/01/23.
//

import UIKit

extension String {
    
    var htmlDecoded: String {
        // matches <br />, <br/> and <p/>
        let regex = "(?:(?:(?:\\<br\\ \\/\\>))|(?:(?:\\<br\\/\\>))|(?:(?:\\<p\\/\\>)))"
        let newString: String = replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: regex, with: "<br>", options: .regularExpression)
        return newString.htmlToAttributedString?.string ?? self
    }
    
    private var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        return try? .init(data: data, options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil)
    }
}
