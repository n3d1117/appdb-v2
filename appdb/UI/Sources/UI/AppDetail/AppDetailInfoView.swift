//
//  AppDetailInfoView.swift
//  
//
//  Created by ned on 10/01/23.
//

import SwiftUI

public struct AppDetailInfoView: View {
    
    @ScaledMetric private var spacing: CGFloat = 12
    @ScaledMetric private var maxDeveloperWidth: CGFloat = 100
    
    let version: String?
    let updateDate: Date?
    let size: (size: Double, unit: String)?
    let monthlyDownloads: Int
    let publisherName: String?
    let rating: (count: Int, stars: Double)?
    let censorRating: String?
    let languages: [String]?
    
    public init(version: String?, updateDate: Date?, size: (size: Double, unit: String)?, monthlyDownloads: Int, publisherName: String?, rating: (count: Int, stars: Double)?, censorRating: String?, languages: [String]?) {
        self.version = version
        self.updateDate = updateDate
        self.size = size
        self.monthlyDownloads = monthlyDownloads
        self.publisherName = publisherName
        self.rating = rating
        self.censorRating = censorRating
        self.languages = languages
    }
    
    public var body: some View {
        if !hasSomethingToShow { EmptyView() } else {
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(spacing: spacing) {
                    Divider()
                        .padding(.horizontal)
                    
                    HStack(alignment: .top) {
                        Group {
                            if let version {
                                versionView(version: version, updateDate: updateDate)
                                    .padding(.horizontal, spacing)
                            }
                            
                            if monthlyDownloads > .zero {
                                if let _ = version, let _ = updateDate {
                                    verticalDivider
                                }
                                
                                downloadsView
                                    .padding(.horizontal, spacing)
                            }
                            
                            if let rating {
                                verticalDivider
                                
                                ratingsView(rating: rating)
                                    .padding(.horizontal, spacing)
                            }
                        }
                        
                        Group {
                            if let publisherName {
                                verticalDivider
                                
                                developerView(publisherName: publisherName)
                                    .padding(.horizontal, spacing)
                            }
                            
                            if let size, size.size > .zero {
                                verticalDivider
                                
                                sizeView(size: size)
                                    .padding(.horizontal, spacing)
                            }
                            
                            if let languages {
                                verticalDivider
                                
                                languageView(languages: languages)
                                    .padding(.horizontal, spacing)
                            }
                            
                            if let censorRating {
                                verticalDivider
                                
                                ageView(censorRating: censorRating)
                                    .padding(.horizontal, spacing)
                            }
                        }
                    }
                    .fixedSize()
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                }
                .scrollViewContentRTLFriendly()
            }
            .scrollViewRTLFriendly()
            .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private var hasSomethingToShow: Bool {
        let totalInfo: [Any?] = [version, updateDate, size, publisherName, rating, censorRating, languages]
        return monthlyDownloads > .zero || !totalInfo.compactMap { $0 }.isEmpty
    }
    
    @ViewBuilder private var verticalDivider: some View {
        Divider()
            .padding(.vertical)
    }
    
    @ViewBuilder private func versionView(version: String, updateDate: Date?) -> some View {
        buildBlock(title: "Version") {
            Text(version)
        } subtitle: {
            if let updateDate {
                Text(updateDate.formatted(.relative(presentation: .numeric)))
            } else {
                Text("Recently")
            }
        }
    }
    
    @ViewBuilder private func sizeView(size: (size: Double, unit: String)) -> some View {
        buildBlock(title: "Size") {
            Text(size.size.formatted())
        } subtitle: {
            Text(size.unit)
        }
    }
    
    @ViewBuilder private var downloadsView: some View {
        buildBlock(title: "Downloads") {
            Text(monthlyDownloads.formatted())
        } subtitle: {
            Text("This month")
        }
    }
    
    @ViewBuilder private func developerView(publisherName: String) -> some View {
        buildBlock(title: "Developer") {
            Image(systemName: "person.crop.square")
                .padding(.top, 2)
                .padding(.bottom, 4)
        } subtitle: {
            Text(publisherName)
                .frame(maxWidth: maxDeveloperWidth)
        }
    }
    
    @ViewBuilder private func ratingsView(rating: (count: Int, stars: Double)) -> some View {
        buildBlock(title: "\(rating.count.formatted()) \(rating.count == 1 ? "rating" : "ratings")") {
            let stringRating = NumberFormatter.ratingsNumberFormatter
                .string(from: rating.stars as NSNumber) ?? String(format: "%.1f", rating.stars)
            Text(stringRating)
                .padding(.bottom, -1)
        } subtitle: {
            HStack(spacing: 1) {
                ForEach(0..<Int(rating.stars), id: \.self) { _ in
                    Image(systemName: "star.fill")
                }
                
                if rating.stars != floor(rating.stars) {
                    Image(systemName: "star.leadinghalf.filled")
                }
                
                ForEach(0..<Int(Double(5) - rating.stars), id: \.self) { _ in
                    Image(systemName: "star")
                }
            }
            .foregroundColor(.primary.opacity(0.4))
        }
    }
    
    @ViewBuilder private func languageView(languages: [String]) -> some View {
        let firstLanguage = languages.first ?? "EN"
        
        buildBlock(title: "Language") {
            Text(firstLanguage)
        } subtitle: {
            if languages.count > 1 {
                Text("+\(languages.count - 1) More")
            } else {
                Text(Locale.current.localizedString(forLanguageCode: firstLanguage) ?? "")
            }
        }
    }
    
    @ViewBuilder private func ageView(censorRating: String) -> some View {
        buildBlock(title: "Age") {
            Text(censorRating)
        } subtitle: {
            Text("Years Old")
        }
    }
    
    @ViewBuilder private func buildBlock<V1: View, V2: View>(
        title: String,
        @ViewBuilder body: () -> V1,
        @ViewBuilder subtitle: () -> V2
    ) -> some View {
        VStack(spacing: 5) {
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary.opacity(0.7))
            
            VStack(spacing: 2) {
                body()
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.semibold)
                subtitle()
                    .font(.caption)
            }
            .frame(alignment: .top)
            .foregroundColor(.primary.opacity(0.7))
        }
    }
}

struct AppDetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailInfoView(
            version: "1.0",
            updateDate: .now.addingTimeInterval(-15000),
            size: (size: 12.1, unit: "MB"),
            monthlyDownloads: 213,
            publisherName: "Test",
            rating: (count: 12, stars: 2.3),
            censorRating: "4+",
            languages: ["IT"]
        )
        .padding(.vertical)
        .border(.red)
        .previewLayout(.sizeThatFits)
    }
}
