//
//  NewsView.swift
//  appdb
//
//  Created by ned on 07/01/23.
//

import SwiftUI
import Models
import Networking
import UI

struct NewsView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .failed(let error):
                GenericErrorView(error: error.localizedDescription) {
                    await viewModel.loadNews()
                }
            case .loading:
                List {
                    ForEach(0..<25) { _ in
                        Text("Example news title currently loading")
                    }
                    .placeholder()
                }
            case .success(let news):
                List {
                    ForEach(news) { newsEntry in
                        Text(newsEntry.title)
                    }
                }
                .refreshable { await viewModel.loadNews() }
            }
        }
        .animation(.default, value: viewModel.state)
        .task { await viewModel.loadNews() }
    }
}

extension NewsView {
    @MainActor final class ViewModel: ObservableObject {
        @Dependency(Dependencies.apiService) private var apiService: APIService
        
        @Published private(set) var state: State<[NewsEntry]> = .loading
        
        func loadNews() async {
            do {
                let response: APIResponse<[NewsEntry]> = try await apiService.request(.news(.list(limit: 25)))
                state = .success(response.data)
            } catch {
                state = .failed(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with mocked news
            let _ = Dependencies.apiService.register {
                .mock(.data([
                    NewsEntry(id: "1", title: "One"),
                    NewsEntry(id: "2", title: "Two")
                ]))
            }
            let viewModel = NewsView.ViewModel()
            NewsView(viewModel: viewModel)
                .previewDisplayName("Mocked")
            
            // Preview with error
            let _ = Dependencies.apiService.register {
                .mock(.error(.example))
            }
            let viewModel2 = NewsView.ViewModel()
            NewsView(viewModel: viewModel2)
                .previewDisplayName("Error")
            
            // Preview while loading
            let _ = Dependencies.apiService.register {
                .mock(.loading())
            }
            let viewModel3 = NewsView.ViewModel()
            NewsView(viewModel: viewModel3)
                .previewDisplayName("Loading")
        }
    }
}