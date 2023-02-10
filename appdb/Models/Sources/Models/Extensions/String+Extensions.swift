//
//  String+Extensions.swift
//  
//
//  Created by ned on 18/01/23.
//

import UIKit
import HTML2Markdown

extension String {
    var htmlToMarkdown: String {
        HTMLParser.htmlToMarkdown(self
            .replacingOccurrences(of: "\r\n", with: "")
            .replacingOccurrences(of: "<br />\n ", with: "\n")
            .replacingOccurrences(of: "<br />\n", with: "\n")
            .replacingOccurrences(of: "<br />", with: "<br>")
        )
    }
}
