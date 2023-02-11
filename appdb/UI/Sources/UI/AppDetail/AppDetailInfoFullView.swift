//
//  AppDetailInfoFullView.swift
//  
//
//  Created by ned on 11/02/23.
//

import SwiftUI

public struct AppDetailInfoFullView: View {
    
    @ScaledMetric private var spacing: CGFloat = 8
    @ScaledMetric private var rowVerticalPadding: CGFloat = 10
    
    let developer: String?
    let bundleID: String?
    let genreName: String?
    let price: String?
    let updatedDate: Date?
    let version: String?
    let size: (size: Double, unit: String)?
    let rating: (count: Int, stars: Double)?
    let censorRating: String?
    let compatibilityString: String?
    let languages: [String]?
    
    private let entries: [Entry]
    
    public init(developer: String?, bundleID: String?, genreName: String?, price: String?, updatedDate: Date?, version: String?, size: (size: Double, unit: String)?, rating: (count: Int, stars: Double)?, censorRating: String?, compatibilityString: String?, languages: [String]?) {
        self.developer = developer
        self.bundleID = bundleID
        self.genreName = genreName
        self.price = price
        self.updatedDate = updatedDate
        self.version = version
        self.size = size
        self.rating = rating
        self.censorRating = censorRating
        self.compatibilityString = compatibilityString
        self.languages = languages
        
        self.entries = [
            .init(text: "Developer", image: "person", value: developer),
            .init(text: "Bundle ID", image: "qrcode", value: bundleID),
            .init(text: "Category", image: "list.bullet", value: genreName),
            .init(text: "Price", image: "dollarsign.circle", value: price),
            .init(text: "Updated", image: "calendar", value: updatedDate?.formatted()),
            .init(text: "Version", image: "number", value: version),
            .init(text: "Size", image: "externaldrive", value: size.map { "\($0.size.formatted()) \($0.unit)" }),
            .init(text: "Customer ratings", image: "hand.thumbsup", value: rating.map { "\(NumberFormatter.ratingsNumberFormatter.string(from: $0.stars as NSNumber) ?? String(format: "%.1f", $0.stars)) stars (\($0.count.formatted()))"
            }),
            .init(text: "Rating", image: "hand.raised", value: censorRating),
            .init(text: "Compatibility", image: "ipad.and.iphone", value: compatibilityString),
            .init(text: "Languages", image: "quote.bubble", value: languages?.joined(separator: ", "))
        ].filter({ $0.value != nil })
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text("Information")
                .font(.title3)
                .fontWeight(.semibold)
            
            VStack(spacing: 0) {
                ForEach(Array(zip(entries.indices, entries)), id: \.1) { index, entry in
                    entryView(text: entry.text, image: entry.image, value: entry.value)
                        .overlay(alignment: .bottom, content: {
                            if index != entries.count - 1 {
                                Divider()
                            }
                        })
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(Color.gray.opacity(0.15), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
    
    @ViewBuilder private func entryView(text: String, image: String, value: String?) -> some View {
        if let value {
            LabeledContent {
                Text(value)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.trailing)
            } label: {
                Label {
                    Text(text)
                } icon: {
                    Image(systemName: image)
                }
                
            }
            .font(.subheadline)
            .padding(.vertical, rowVerticalPadding)
        }
    }
    
    private var formattedSize: String? {
        guard let size else { return nil }
        return "\(size.size.formatted()) \(size.unit)"
    }
    
    private struct Entry: Identifiable, Hashable {
        let text: String
        let image: String
        let value: String?
        
        var id: String { text }
    }
}

struct AppDetailInfoFullView_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailInfoFullView(
            developer: "Example Seller",
            bundleID: "example.bundle.id",
            genreName: "Genre",
            price: "2.99 EUR",
            updatedDate: .now.addingTimeInterval(-15000),
            version: "2.0.3",
            size: (size: 12.9, unit: "MB"),
            rating: (count: 456, stars: 2.9),
            censorRating: "Rated 9+",
            compatibilityString: "Compatible",
            languages: ["IT", "EN"]
        )
        .padding()
        .border(.red)
        .previewLayout(.sizeThatFits)
    }
}
