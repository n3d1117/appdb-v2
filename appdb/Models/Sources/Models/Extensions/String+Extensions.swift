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
        (try? HTMLParser().parse(html: self).toMarkdown(options: .unorderedListBullets)) ?? self
    }
}
