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
                    Group {
                        Button("toggle") {
                            viewModel.grid.toggle()
                        }
                        if viewModel.grid {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60), spacing: 20, alignment: .top)], spacing: 20) {
                                ForEach(apps) { app in
                                    AppGridView(name: app.name, image: app.image)
                                }
                            }
                        } else {
                            LazyVStack {
                                ForEach(apps) { app in
                                    AppListView(name: app.name, image: app.image)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .refreshable { await viewModel.loadApps() }
            }
        }
        .animation(.default, value: viewModel.state)
        .animation(.default, value: viewModel.grid)
        .task { await viewModel.loadApps() }
    }
}

extension AppsView {
    @MainActor final class ViewModel: ObservableObject {
        @Dependency(Dependencies.apiService) private var apiService: APIService
        
        @Published private(set) var state: State<[Models.App]> = .loading
        @Published var grid: Bool = true
        
        func loadApps() async {
            do {
                let response: APIResponse<[Models.App]> = try await apiService.request(.apps(.list(type: .ios)))
                state = .success(response.data)
            } catch {
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
