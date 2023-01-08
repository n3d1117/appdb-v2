//
//  ContentView.swift
//  appdb-v2
//
//  Created by ned on 07/01/23.
//

import SwiftUI
import Models
import Networking

struct ContentView: View {
    
    private let service = APIService()
    
    @State private var news: [NewsEntry] = []
    
    var body: some View {
        List {
            ForEach(news) { newsEntry in
                Text(newsEntry.title)
            }
        }
        .task {
            do {
                let newsList: NewsList = try await service.request(.news(.list(limit: 500)))
                news = newsList.data
            } catch {
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
