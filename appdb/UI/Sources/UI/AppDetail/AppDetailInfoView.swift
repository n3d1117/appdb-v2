//
//  AppDetailInfoView.swift
//  
//
//  Created by ned on 10/01/23.
//

import SwiftUI

public struct AppDetailInfoView: View {
    
    @ScaledMetric private var spacing: CGFloat = 12
    @ScaledMetric private var maxDeveloperWidth: CGFloat = 130
    @ScaledMetric(relativeTo: .caption2) private var chevronSize: CGFloat = 9
    
    let version: String?
    let updateDate: Date?
    let size: (size: Double, unit: String)?
    let monthlyDownloads: Int
    let publisherName: String?
    let rating: (count: Int, stars: Double)?
    let censorRating: String?
    let languages: [String]?
    let website: URL?
    let isTweaked: Bool
    
    let onDeveloperTapped: () -> Void
    let onWebsiteTapped: () -> Void
    
    public init(version: String?, updateDate: Date?, size: (size: Double, unit: String)?, monthlyDownloads: Int, publisherName: String?, rating: (count: Int, stars: Double)?, censorRating: String?, languages: [String]?, website: URL?, isTweaked: Bool, onDeveloperTapped: @escaping () -> Void, onWebsiteTapped: @escaping () -> Void) {
        self.version = version
        self.updateDate = updateDate
        self.size = size
        self.monthlyDownloads = monthlyDownloads
        self.publisherName = publisherName
        self.rating = rating
        self.censorRating = censorRating
        self.languages = languages
        self.website = website
        self.isTweaked = isTweaked
        self.onDeveloperTapped = onDeveloperTapped
        self.onWebsiteTapped = onWebsiteTapped
    }
    
    public var body: some View {
        if !hasSomethingToShow { EmptyView() } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Group {
                        if isTweaked {
                            tweakedView
                                .padding(.horizontal, spacing)
                        }
                        
                        if let version {
                            if isTweaked {
                                verticalDivider
                            }
                            
                            versionView(version: version, updateDate: updateDate)
                                .padding(.horizontal, spacing)
                        }
                        
                        if monthlyDownloads > .zero {
                            verticalDivider
                            
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
                        
                        if let website {
                            verticalDivider
                            
                            websiteView(website: website)
                                .padding(.horizontal, spacing)
                        }
                    }
                }
                .fixedSize()
                .padding(.horizontal)
                .scrollViewContentRTLFriendly()
            }
            .scrollViewRTLFriendly()
            .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private var hasSomethingToShow: Bool {
        let totalInfo: [Any?] = [version, updateDate, size, publisherName, rating, censorRating, languages]
        return isTweaked || monthlyDownloads > .zero || !totalInfo.compactMap { $0 }.isEmpty
    }
    
    @ViewBuilder private var verticalDivider: some View {
        Divider()
            .padding(.vertical)
    }
    
    @ViewBuilder private var tweakedView: some View {
        buildBlock(title: "App type") {
            Image(systemName: "hammer")
                .font(.headline)
        } subtitle: {
            Text("Tweaked")
        }
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
        } subtitle: {
            Button {
                onDeveloperTapped()
            } label: {
                HStack(spacing: 2) {
                    Text(publisherName)
                    Image(systemName: "chevron.right")
                        .font(.system(size: chevronSize))
                }
                .frame(maxWidth: maxDeveloperWidth)
            }
        }
    }
    
    @ViewBuilder private func ratingsView(rating: (count: Int, stars: Double)) -> some View {
        buildBlock(title: "\(rating.count.formatted()) \(rating.count == 1 ? "rating" : "ratings")") {
            let stringRating = NumberFormatter.ratingsNumberFormatter
                .string(from: rating.stars as NSNumber) ?? String(format: "%.1f", rating.stars)
            Text(stringRating)
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
            .offset(y: -2)
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
    
    @ViewBuilder private func websiteView(website: URL) -> some View {
        buildBlock(title: "Website") {
            Image(systemName: "globe")
                .font(.title3)
        } subtitle: {
            Button {
                onWebsiteTapped()
            } label: {
                HStack(spacing: 2) {
                    Text("Visit")
                    Image(systemName: "chevron.right")
                        .font(.system(size: chevronSize))
                }
            }
        }
    }
    
    @ViewBuilder private func buildBlock<V1: View, V2: View>(
        title: String,
        @ViewBuilder body: () -> V1,
        @ViewBuilder subtitle: () -> V2
    ) -> some View {
        VStack {
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary.opacity(0.7))
            
            Spacer(minLength: 5)
            
            Group {
                body()
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.semibold)
                
                Spacer(minLength: 2)
                
                subtitle()
                    .font(.caption)
            }
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
            languages: ["IT"],
            website: .init(string: "https://appdb.to"),
            isTweaked: true,
            onDeveloperTapped: {},
            onWebsiteTapped: {}
        )
        .padding(.vertical)
        .border(.red)
        .previewLayout(.sizeThatFits)
    }
}
