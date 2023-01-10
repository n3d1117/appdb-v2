//
//  AppDetailInfoView.swift
//  
//
//  Created by ned on 10/01/23.
//

import SwiftUI

public struct AppDetailInfoView: View {
    
    public init() {}
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ratingsView
                    .padding(.trailing, 10)
                
                verticalDivider
                
                developerView
                    .padding(.horizontal, 10)
                
                verticalDivider
                
                versionView
                    .padding(.horizontal, 10)
                
                verticalDivider
                
                sizeView
                    .padding(.horizontal, 10)
                
                verticalDivider
                
                downloadsView
                    .padding(.leading, 10)
            }
            .padding(.horizontal)
        }
        .frame(height: 65)
    }
    
    @ViewBuilder private var verticalDivider: some View {
        Divider()
            .padding(.vertical)
    }
    
    @ViewBuilder private var ratingsView: some View {
        VStack(spacing: 4) {
            Text("604k ratings".uppercased())
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            VStack {
                Text("4.8")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.semibold)
                
                HStack(spacing: 1) {
                    ForEach(0..<5) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 12, design: .rounded))
                    }
                }
            }
            .frame(height: 45, alignment: .top)
        }
    }
    
    @ViewBuilder private var developerView: some View {
        VStack(spacing: 5) {
            Text("developer".uppercased())
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            VStack(spacing: 4) {
                Image(systemName: "person.crop.square")
                    .font(.system(size: 24))
                
                Text("TikTok Ltd.")
                    .font(.caption)
            }
            .frame(height: 45, alignment: .top)
        }
    }
    
    @ViewBuilder private var versionView: some View {
        VStack(spacing: 5) {
            Text("version".uppercased())
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            VStack(spacing: 2) {
                Text("159.0")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.semibold)
                Text("2d ago")
                    .font(.caption)
            }
            .frame(height: 45, alignment: .top)
        }
    }
    
    @ViewBuilder private var sizeView: some View {
        VStack(spacing: 5) {
            Text("size".uppercased())
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            VStack(spacing: 2) {
                Text("111.1")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.semibold)
                Text("MB")
                    .font(.caption)
            }
            .frame(height: 45, alignment: .top)
        }
    }
    
    @ViewBuilder private var downloadsView: some View {
        VStack(spacing: 5) {
            Text("downloads".uppercased())
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            VStack(spacing: 2) {
                Text("19")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.semibold)
                Text("This week")
                    .font(.caption)
            }
            .frame(height: 45, alignment: .top)
        }
    }
}

struct AppDetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailInfoView()
            .border(.red)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
