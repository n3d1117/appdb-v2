//
//  AppLinksView.swift
//  
//
//  Created by ned on 14/02/23.
//

import SwiftUI
import Models
import Networking
import UI

public struct AppLinksView: View {
    
    @StateObject var viewModel: ViewModel
    
    public init(id: Int, type: AppType, dominantColor: UIColor?) {
        _viewModel = StateObject(wrappedValue: .init(id: id, type: type, dominantColor: dominantColor))
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                        .tint(.gray)
                    
                case .failed(let error):
                    GenericErrorView(error: error.localizedDescription)
                    
                case .success(let versions):
                    if versions.isEmpty {
                        noLinksView
                    } else {
                        linksView(for: versions)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onFirstAppear { await viewModel.loadAppLinks() }
            .animation(.default, value: viewModel.state)
            .background {
                if let dominantColor = viewModel.dominantColor {
                    LinearGradient(gradient: Gradient(colors: [Color(dominantColor).opacity(0.3), Color(UIColor.systemBackground)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea(.all)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    SheetDismissButton()
                }
            }
        }
    }
    
    @ViewBuilder private var noLinksView: some View {
        Text("No links available")
            .font(.title2)
            .foregroundColor(.secondary)
    }
    
    @ViewBuilder private func linksView(for versions: [LinksResponse.Version]) -> some View {
        List {
            ForEach(versions) { version in
                if !version.links.isEmpty {
                    Section {
                        ForEach(version.links) { link in
                            Text(link.host)
                                .listRowBackground(Color.gray.opacity(0.15))
                        }
                    } header: {
                        Text(version.number)
                            .font(.headline)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
}

extension AppLinksView {
    @MainActor final class ViewModel: ObservableObject {
        // MARK: - Dependencies
        @Dependency(Dependencies.apiService) private var apiService
        @Dependency(Dependencies.logger) private var logger
        
        // MARK: - Published vars
        @Published private(set) var state: ViewState<[LinksResponse.Version]> = .loading
        
        // MARK: - Constants
        let id: Int
        let type: AppType
        let dominantColor: UIColor?
        
        // MARK: - Initializers
        init(id: Int, type: AppType, dominantColor: UIColor?) {
            self.id = id
            self.type = type
            self.dominantColor = dominantColor
        }
        
        // MARK: - Public
        func loadAppLinks() async {
            do {
                let response: APIResponse<LinksResponse> = try await apiService.request(.links(.get(type: type, trackid: id)))
                let versions = response.data.versions(for: id)
                state = .success(versions)
                logger.log(.debug, "Got \(versions.count) versions")
            } catch {
                logger.log(.error, "Error while loading app links: \(error)")
                state = .failed(error)
            }
        }
    }
}

struct AppDetailDownloadsPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with mocked links
            let _ = Dependencies.apiService.register { .mock(.data(LinksResponse.mock)) }
            let viewModel = AppLinksView.ViewModel(id: App.mock.id, type: .ios, dominantColor: .blue)
            AppLinksView(viewModel: viewModel)
                .previewDisplayName("Mocked")
            
            // Preview with error
            let _ = Dependencies.apiService.register { .mock(.error(.example)) }
            let viewModel2 = AppLinksView.ViewModel(id: 1, type: .ios, dominantColor: .blue)
            AppLinksView(viewModel: viewModel2)
                .previewDisplayName("Error")
            
            // Preview while loading
            let _ = Dependencies.apiService.register { .mock(.loading()) }
            let viewModel3 = AppLinksView.ViewModel(id: 1, type: .ios, dominantColor: .blue)
            AppLinksView(viewModel: viewModel3)
                .previewDisplayName("Loading")
        }
        .frame(height: 300)
    }
}

#if DEBUG
extension AppLinksView {
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}
#endif
