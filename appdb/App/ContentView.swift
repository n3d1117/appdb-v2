//
//  ContentView.swift
//  appdb-v2
//
//  Created by ned on 07/01/23.
//

import SwiftUI
import Models
import Networking
import Factory

struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.news) { newsEntry in
                Text(newsEntry.title)
            }
        }
        .task {
            try? await viewModel.loadNews()
        }
    }
}

extension ContentView {
    @MainActor final class ViewModel: ObservableObject {
        @Injected(Dependencies.apiService) private var apiService: APIService
        
        @Published private(set) var news: [NewsEntry] = []
        
        func loadNews() async throws {
            let newsList: NewsList = try await apiService.request(.news(.list(limit: 25)))
            news = newsList.data
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let _ = Dependencies.apiService.register {
            .mock(NewsList(data: [
                .init(id: "1", title: "One"),
                .init(id: "2", title: "Two")
            ]))
        }
        ContentView()
    }
}
