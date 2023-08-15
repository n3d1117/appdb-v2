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
        #if DEBUG
        let _ = Self._printChanges()
        #endif
        
        ZStack {
            switch viewModel.state {
            case .failed(let error):
                GenericErrorView(error: error.localizedDescription) {
                    await viewModel.loadNews()
                }
            case .loading:
                ProgressView()
            case .success(let news):
                List {
                    ForEach(news) { newsEntry in
                        Text(newsEntry.title)
                    }
                }
                .refreshable { await viewModel.loadNews() }
            }
        }
        .onFirstAppear { await viewModel.loadNews() }
        .navigationTitle("News")
        .animation(.default, value: viewModel.state)
    }
}

extension NewsView {
    @MainActor final class ViewModel: ObservableObject {
        @Dependency(Dependencies.apiService) private var apiService
        @Dependency(Dependencies.logger) private var logger
        
        @Published private(set) var state: ViewState<[NewsEntry]> = .loading
        
        func loadNews() async {
            do {
                // TODO: Paginated response
                let response: APIResponse<[NewsEntry]> = try await apiService.request(.news(.list(length: 10_000)))
                state = .success(response.data)
            } catch {
                logger.log(.error, "Error while fetching news: \(error)")
                state = .failed(error)
            }
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with mocked news
            let _ = Dependencies.apiService.register {
                .mock(.data([
                    NewsEntry(id: 1, title: "One"),
                    NewsEntry(id: 2, title: "Two")
                ]))
            }
            let viewModel = NewsView.ViewModel()
            NewsView(viewModel: viewModel)
                .previewDisplayName("Mocked")
            
            // Preview with error
            let _ = Dependencies.apiService.register { .mock(.error(.example)) }
            let viewModel2 = NewsView.ViewModel()
            NewsView(viewModel: viewModel2)
                .previewDisplayName("Error")
            
            // Preview while loading
            let _ = Dependencies.apiService.register { .mock(.loading()) }
            let viewModel3 = NewsView.ViewModel()
            NewsView(viewModel: viewModel3)
                .previewDisplayName("Loading")
        }
    }
}
