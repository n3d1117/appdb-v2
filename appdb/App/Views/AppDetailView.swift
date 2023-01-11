//
//  AppDetailView.swift
//  appdb
//
//  Created by ned on 10/01/23.
//

import SwiftUI
import Models
import Networking
import UI

struct AppDetailView: View {
    
    @StateObject var viewModel: ViewModel
    
    public init(id: String) {
        _viewModel = StateObject(wrappedValue: .init(id: id))
    }
    
    public init(app: Models.App) {
        _viewModel = StateObject(wrappedValue: .init(app: app))
    }
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .failed(let error):
                GenericErrorView(error: error.localizedDescription) {
                    await viewModel.loadAppDetails()
                }
            case .success(let app):
                ScrollView {
                    VStack(spacing: 0) {
                        AppDetailHeaderView(
                            name: app.name,
                            image: .init(string: app.image.absoluteString.replacingOccurrences(of: "100x100bb.jpg", with: "200x200bb.jpg"))!,
                            category: app.genre.name
                        )
                        .padding()
                        
                        AppDetailInfoView(
                            version: app.version,
                            updateDate: app.lastUpdated,
                            size: app.size,
                            monthlyDownloads: app.clicksMonth,
                            publisherName: app.publisher,
                            rating: app.ratings,
                            censorRating: app.censorRating,
                            languages: app.languages
                        )
                    }
                }
                .refreshable { await viewModel.loadAppDetails() }
            }
        }
        .animation(.default, value: viewModel.state)
        .task { await viewModel.loadAppDetails() }
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension AppDetailView {
    @MainActor final class ViewModel: ObservableObject {
        @Dependency(Dependencies.apiService) private var apiService: APIService
        
        @Published private(set) var state: State<Models.App> = .loading
        
        let id: String
        
        init(id: String) {
            self.id = id
        }
        
        init(app: Models.App) {
            self.id = app.id
            self.state = .success(app)
        }
        
        func loadAppDetails() async {
            do {
                let response: APIResponse<[Models.App]> = try await apiService.request(.apps(.detail(type: .ios, trackid: id)))
                guard let app = response.data.first else {
                    state = .failed(APIError.missingData)
                    return
                }
                state = .success(app)
            } catch {
                state = .failed(error)
            }
        }
    }
}

struct AppDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with mocked app
            let _ = Dependencies.apiService.register {
                .mock(.data([App.mock]))
            }
            let viewModel = AppDetailView.ViewModel(id: "1")
            AppDetailView(viewModel: viewModel)
                .previewDisplayName("Mocked")
            
            // Preview with error
            let _ = Dependencies.apiService.register { .mock(.error(.example)) }
            let viewModel2 = AppDetailView.ViewModel(id: "1")
            AppDetailView(viewModel: viewModel2)
                .previewDisplayName("Error")
            
            // Preview while loading
            let _ = Dependencies.apiService.register { .mock(.loading()) }
            let viewModel3 = AppDetailView.ViewModel(id: "1")
            AppDetailView(viewModel: viewModel3)
                .previewDisplayName("Loading")
        }
    }
}

#if DEBUG
extension AppDetailView {
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}
#endif
