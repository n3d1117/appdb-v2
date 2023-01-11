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
    
    let version: String
    let updateDate: Date
    let size: (size: Double, unit: String)
    let monthlyDownloads: Int
    let publisherName: String
    let rating: (count: Int, stars: Double)?
    let censorRating: String
    let languages: [String]
    
    public init(version: String, updateDate: Date, size: (size: Double, unit: String), monthlyDownloads: Int, publisherName: String, rating: (count: Int, stars: Double)?, censorRating: String, languages: [String]) {
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
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(spacing: spacing) {
                Divider()
                    .padding(.horizontal)
                
                HStack(alignment: .top) {
                    Group {
                        versionView
                            .padding(.horizontal, spacing)
                        
                        verticalDivider
                        
                        downloadsView
                            .padding(.horizontal, spacing)
                        
                        verticalDivider
                        
                        sizeView
                            .padding(.horizontal, spacing)
                        
                        verticalDivider
                    }
                    
                    Group {
                        developerView
                            .padding(.horizontal, spacing)
                        
                        verticalDivider
                        
                        ratingsView
                            .padding(.horizontal, spacing)
                        
                        verticalDivider
                        
                        languageView
                            .padding(.horizontal, spacing)
                        
                        verticalDivider
                        
                        ageView
                            .padding(.horizontal, spacing)
                    }
                }
                    .fixedSize()
                    .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    @ViewBuilder private var verticalDivider: some View {
        Divider()
            .padding(.vertical)
    }
    
    @ViewBuilder private var versionView: some View {
        buildBlock(title: "Version") {
            Text(version)
                .modifier(BodyStyle())
            Text(updateDate.formatted(.relative(presentation: .numeric)))
                .modifier(SubtitleStyle())
        }
    }
    
    @ViewBuilder private var sizeView: some View {
        buildBlock(title: "Size") {
            Text(size.size.formatted())
                .modifier(BodyStyle())
            Text(size.unit)
                .modifier(SubtitleStyle())
        }
    }
    
    @ViewBuilder private var downloadsView: some View {
        buildBlock(title: "Downloads") {
            Text(monthlyDownloads.formatted())
                .modifier(BodyStyle())
            Text("This month")
                .modifier(SubtitleStyle())
        }
    }
    
    @ViewBuilder private var developerView: some View {
        buildBlock(title: "Developer") {
            Image(systemName: "person.crop.square")
                .modifier(BodyStyle())
                .padding(.top, 1)
                .padding(.bottom, 1)
            
            Text(publisherName)
                .modifier(SubtitleStyle())
                .frame(maxWidth: maxDeveloperWidth)
        }
    }
    
    @ViewBuilder private var ratingsView: some View {
        if let rating {
            buildBlock(title: "\(rating.count.formatted()) ratings") {
                Text(String(format: "%.1f", rating.stars))
                    .modifier(BodyStyle())
                    .padding(.bottom, -1)
                
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
                .modifier(SubtitleStyle())
                .foregroundColor(.primary.opacity(0.4))
            }
        }
    }
    
    @ViewBuilder private var languageView: some View {
        buildBlock(title: "Language") {
            let firstLanguage = languages.first ?? "EN"
            let hfFirstLanguage = Locale.current.localizedString(forLanguageCode: firstLanguage) ?? ""
            
            Text(firstLanguage)
                .modifier(BodyStyle())
            
            Group {
                if languages.count > 1 {
                    Text("+\(languages.count - 1) More")
                } else {
                    Text(hfFirstLanguage)
                }
            }.modifier(SubtitleStyle())
        }
    }
    
    @ViewBuilder private var ageView: some View {
        buildBlock(title: "Age") {
            Text(censorRating)
                .modifier(BodyStyle())
            
            Text("Years Old")
                .modifier(SubtitleStyle())
        }
    }
    
    @ViewBuilder private func buildBlock<V: View>(title: String, @ViewBuilder body: () -> V) -> some View {
        VStack(spacing: 5) {
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary.opacity(0.7))
            
            VStack(spacing: 2) {
                body()
            }
            .frame(alignment: .top)
            .foregroundColor(.primary.opacity(0.7))
        }
    }
    
    private struct BodyStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.system(.title2, design: .rounded))
                .fontWeight(.semibold)
        }
    }
    
    private struct SubtitleStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(.caption)
        }
    }
}

struct AppDetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailInfoView(
            version: "159.0",
            updateDate: .now.addingTimeInterval(-15000),
            size: (size: 111.1, unit: "MB"),
            monthlyDownloads: 1_323,
            publisherName: "Very very long very long name TikTok Ltd.",
            rating: (count: 6_090, stars: 4.8),
            censorRating: "12+",
            languages: ["IT"]
        )
        .padding(.vertical)
        .border(.red)
        .previewLayout(.sizeThatFits)
    }
}
