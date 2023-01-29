//
//  AppsView.swift
//  appdb
//
//  Created by ned on 09/01/23.
//

import SwiftUI
import Models
import Networking
import UI

struct AppsView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        #if DEBUG
        let _ = Self._printChanges()
        #endif
        
        ZStack {
            switch viewModel.state {
            case .failed(let error):
                GenericErrorView(error: error.localizedDescription) {
                    await viewModel.loadApps()
                }
            case .loading:
                ProgressView()
            case .success(let apps):
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60), spacing: 20, alignment: .top)], spacing: 20) {
                        ForEach(apps) { app in
                            NavigationLink {
                                AppDetailView(app: app)
                            } label: {
                                AppGridView(name: app.name, image: app.image.iconHigherQuality())
                                    .onAppear {
                                        if app == apps.last {
                                            viewModel.currentTask = Task {
                                                await viewModel.loadMore()
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    .padding()
                    
                    if viewModel.isLoadingMore {
                        ProgressView()
                            .padding()
                    }
                }
                .refreshable { await viewModel.loadApps() }
            }
        }
        .animation(.default, value: viewModel.state)
        .onFirstAppear { await viewModel.loadApps() }
    }
}

extension AppsView {
    @MainActor final class ViewModel: ObservableObject {
        @Dependency(Dependencies.apiService) private var apiService: APIService
        
        @Published private(set) var state: ViewState<[Models.App]> = .loading
        @Published private(set) var page: Int = 1
        @Published private(set) var isLoadingMore: Bool = false
        
        var currentTask: Task<Void, Never>? {
            willSet {
                if let task = currentTask {
                    if task.isCancelled { return }
                    task.cancel()
                }
            }
        }
        
        func loadApps() async {
            do {
                let response: APIResponse<[Models.App]> = try await apiService.request(.apps(.list(type: .ios)))
                state = .success(response.data)
            } catch {
                state = .failed(error)
            }
        }
        
        func loadMore() async {
            do {
                defer { isLoadingMore = false }
                isLoadingMore = true
                if case let .success(statee) = state {
                    self.page += 3
                    let response: APIResponse<[Models.App]> = try await apiService.request(.apps(.list(type: .ios, page: page - 2)))
                    let response2: APIResponse<[Models.App]> = try await apiService.request(.apps(.list(type: .ios, page: page - 1)))
                    let response3: APIResponse<[Models.App]> = try await apiService.request(.apps(.list(type: .ios, page: page)))
                    state = .success(statee + response.data + response2.data + response3.data)
                }
            } catch {
                print(error)
                state = .failed(error)
            }
        }
    }
}

struct AppsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with mocked apps
            let _ = Dependencies.apiService.register {
                .mock(.data([App.mock]))
            }
            let viewModel = AppsView.ViewModel()
            AppsView(viewModel: viewModel)
                .previewDisplayName("Mocked")
            
            // Preview with error
            let _ = Dependencies.apiService.register { .mock(.error(.example)) }
            let viewModel2 = AppsView.ViewModel()
            AppsView(viewModel: viewModel2)
                .previewDisplayName("Error")
            
            // Preview while loading
            let _ = Dependencies.apiService.register { .mock(.loading()) }
            let viewModel3 = AppsView.ViewModel()
            AppsView(viewModel: viewModel3)
                .previewDisplayName("Loading")
        }
    }
}
