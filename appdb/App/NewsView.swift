//
//  NewsView.swift
//  appdb-v2
//
//  Created by ned on 07/01/23.
//

import SwiftUI
import Models
import Networking
import UI

struct NewsView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        List {
            switch viewModel.state {
            case .loading:
                ForEach(0..<25) { _ in
                    Text("Example news title currently loading")
                }
                .placeholder()
                
            case .failed(let error):
                Text(error.localizedDescription)
                
            case .success(let news):
                ForEach(news) { newsEntry in
                    Text(newsEntry.title)
                }
            }
        }
        .task {
            await viewModel.loadNews()
        }
        .refreshable {
            await viewModel.loadNews()
        }
        .animation(.default, value: viewModel.state)
    }
}

extension NewsView {
    @MainActor final class ViewModel: ObservableObject {
        @Dependency(Dependencies.apiService) private var apiService: APIService
        
        @Published private(set) var state: State<[NewsEntry]> = .loading
        
        func loadNews() async {
            do {
                let newsList: NewsList = try await apiService.request(.news(.list(limit: 25)))
                state = .success(newsList.data)
            } catch {
                state = .failed(error)
            }
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
        NewsView()
    }
}
