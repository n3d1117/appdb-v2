//
//  String+Extensions.swift
//  
//
//  Created by ned on 18/01/23.
//

import UIKit
import Kanna

extension String {
    
    //
    // Decode from HTML using Kanna and keep new line
    //
    // regex from http://buildregex.com
    // matches <br />, <br/> and <p/>
    //
    var htmlDecoded: String {
        let regex = "(?:(?:(?:\\<br\\ \\/\\>))|(?:(?:\\<br\\/\\>))|(?:(?:\\<p\\/\\>)))"
        var newString: String = replacingOccurrences(of: "\n", with: "")
        newString = newString.replacingOccurrences(of: regex, with: "\n", options: .regularExpression)
        return (try? HTML(html: newString, encoding: .utf8).text) ?? self
    }
}
