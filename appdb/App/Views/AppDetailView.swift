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
    @Environment(\.colorScheme) var colorScheme
    
    public init(id: String, type: AppType) {
        _viewModel = StateObject(wrappedValue: .init(id: id, type: type))
    }
    
    public init(app: Models.App, type: AppType) {
        _viewModel = StateObject(wrappedValue: .init(app: app, type: type))
    }
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .tint(.gray)
            
            case .failed(let error):
                GenericErrorView(error: error.localizedDescription) {
                    await viewModel.loadAppDetails()
                }
            
            case .success(let app):
                FittingScrollView {
                    
                    VStack(spacing: 0) {
                        
                        // MARK: - Header
                        AppDetailHeaderView(
                            name: app.name,
                            image: app.image?.iconHigherQuality(),
                            category: app.genre.name,
                            onImage: { image in
                                viewModel.findAverageColor(for: image)
                            },
                            onCategoryTapped: {
                                // TODO
                                print(app.genre.name)
                            }
                        )
                        .padding()
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // MARK: - Info view
                        AppDetailInfoView(
                            version: app.version,
                            updateDate: app.lastUpdated,
                            size: app.size,
                            monthlyDownloads: app.clicksMonth,
                            publisherName: app.publisher,
                            rating: app.ratings,
                            censorRating: app.censorRating,
                            languages: app.languages,
                            website: app.website,
                            isTweaked: app.isTweaked,
                            onDeveloperTapped: {
                                // TODO
                                print(app.publisher)
                            },
                            onWebsiteTapped: {
                                // TODO
                                print(app.website)
                            }
                        )
                        .padding(.vertical)
                        
                        Divider()
                            .padding(.horizontal)
                        
                        if viewModel.isLoadingDetails {
                            Spacer()
                            ProgressView()
                                .tint(.gray)
                            
                        } else {
                            
                            // MARK: - Tweaked versions
                            if let tweakedVersions = app.tweakedVersions?.cydia, !tweakedVersions.isEmpty {
                                AppDetailTweakedVersionsView(numberOfTweaks: tweakedVersions.count) {
                                    // TODO
                                    print(tweakedVersions)
                                }
                                .padding([.top, .horizontal])
                                .padding(.bottom, 10)
                            }
                            
                            // MARK: - Adult notice
                            if app.is18Plus {
                                AppDetailAdultNoticeView()
                                    .padding()
                                
                                Divider()
                                    .padding(.horizontal)
                            }
                            
                            // MARK: - Tweaked notice
                            if app.isTweaked {
                                AppDetailTweakedNoticeView {
                                    // TODO
                                    print(app.originalApp)
                                }
                                .padding()
                                
                                Divider()
                                    .padding(.horizontal)
                            }
                            
                            // MARK: - What's new
                            if viewModel.hasRecentUpdate(app: app) {
                                whatsNewView(for: app)
                            }
                            
                            // MARK: - Screenshots
                            if !viewModel.appScreenshots.isEmpty {
                                AppDetailScreenshots(screenshots: viewModel.appScreenshots)
                                    .padding(.top)
                                
                                // MARK: - Compatibility
                                AppDetailCompatibilityView(compatibilityString: app.compatibilityString)
                                    .padding()
                            }
                            
                            Divider()
                                .padding(.horizontal)
                            
                            // MARK: - Description
                            if let description = app.description, !description.isEmpty {
                                AppDetailDescription(text: description)
                                    .padding()
                                
                                Divider()
                                    .padding(.horizontal)
                            }
                            
                            // MARK: - What's new
                            if !viewModel.hasRecentUpdate(app: app) {
                                whatsNewView(for: app)
                            }
                            
                            // MARK: - Compatibility
                            if viewModel.appScreenshots.isEmpty {
                                Divider()
                                    .padding(.horizontal)
                                
                                AppDetailCompatibilityView(compatibilityString: app.compatibilityString)
                                    .padding()
                            }
                        }
                        
                        Spacer()
                    }
                } onOffsetChange: {
                    viewModel.scrollOffset = $0
                }
                //.refreshable { await viewModel.loadAppDetails() }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onFirstAppear { await viewModel.loadAppDetails() }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if case .success(let app) = viewModel.state {
                    AppDetailMiniIconView(image: app.image)
                        .opacity(viewModel.hasScrolledPastNavigationBar ? 1 : 0)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "icloud.and.arrow.down")
                        .font(.subheadline.weight(.semibold))
                        .opacity(viewModel.hasScrolledPastNavigationBar ? 1 : 0)
                }
            }
        }
        .toolbarBackground(.visible, for: .tabBar)
        .background {
            if let appIconAverageColor = viewModel.appIconAverageColor {
                LinearGradient(gradient: Gradient(colors: [Color(appIconAverageColor).opacity(0.3), Color(UIColor.systemBackground)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea(.all)
            }
        }
        .tint(tintColor)
        .animation(.default, value: viewModel.state)
        .animation(.default, value: viewModel.isLoadingDetails)
        .animation(.default, value: viewModel.appIconAverageColor)
        .animation(.default, value: viewModel.hasScrolledPastNavigationBar)
    }
    
    @ViewBuilder private func whatsNewView(for app: Models.App) -> some View {
        if let whatsNew = app.whatsnew,
           !whatsNew.isEmpty {
            
            AppDetailWhatsNew(text: whatsNew, version: app.version, updatedDate: app.lastUpdated)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            
            Divider()
                .padding(.horizontal)
        }
    }
    
    private var tintColor: Color {
        let proposedColor = colorScheme == .dark
            ? viewModel.increasedBrightnessAverageColor
            : viewModel.decreasedBrightnessAverageColor
        return Color(proposedColor ?? UIColor(.accentColor))
    }
}

extension AppDetailView {
    @MainActor final class ViewModel: ObservableObject {
        
        // MARK: - Dependencies
        @Dependency(Dependencies.apiService) private var apiService: APIService
        @Dependency(Dependencies.imageSizeFetcher) private var imageSizeFetcher: ImageSizeFetcher
        @Dependency(Dependencies.screenshotsCache) private var screenshotsCache: ScreenshotsCacheService
        @Dependency(Dependencies.logger) private var logger
        
        // MARK: - Published vars
        @Published private(set) var state: ViewState<Models.App> = .loading
        @Published private(set) var isLoadingDetails = true
        @Published private(set) var hasScrolledPastNavigationBar = false
        @Published private(set) var appIconAverageColor: UIColor? {
            didSet { calculateAverageColorBrightnessVariants() }
        }
        
        // MARK: - Vars
        private(set) var appScreenshots: [AppDetailScreenshots.Screenshot] = []
        private(set) var increasedBrightnessAverageColor: UIColor?
        private(set) var decreasedBrightnessAverageColor: UIColor?
        
        // MARK: - Constants
        let id: String
        let type: AppType
        
        // MARK: - Initializers
        init(id: String, type: AppType) {
            self.id = id
            self.type = type
        }
        
        init(app: Models.App, type: AppType) {
            self.id = app.id
            self.type = type
            state = .success(app)
        }
        
        // MARK: - Public
        func loadAppDetails() async {
            do {
                defer { isLoadingDetails = false }
                let app = try await loadApp()
                appScreenshots = await loadScreenshots(for: app)
                state = .success(app)
                logger.log(.debug, "loadAppDetails")
            } catch {
                logger.log(.error, "Error while loading app details: \(error)")
                state = .failed(error)
            }
        }
        
        func findAverageColor(for image: UIImage?) {
            appIconAverageColor = image?.findAverageColor()
        }
        
        func hasRecentUpdate(app: Models.App) -> Bool {
            guard let updatedDate = app.lastUpdated,
                  let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: .now) else {
                return false
            }
            return updatedDate >= threeDaysAgo
        }
        
        // MARK: - Private
        private func loadApp() async throws -> Models.App {
            let response: APIResponse<[Models.App]> = try await apiService.request(.apps(.detail(type: type, trackid: id)))
            guard let app = response.data.first else { throw APIError.missingData }
            logger.log(.debug, "loadApp")
            return app
        }
        
        private func loadScreenshots(for app: Models.App) async -> [AppDetailScreenshots.Screenshot] {
            if let cachedScreenshots = await screenshotsCache.first(for: app.id) {
                return cachedScreenshots.map({ (url: $0.url, size: $0.size) })
            } else {
                do {
                    let appScreenshots = try await fetchScreenshots(urls: app.screenshotsUrls)
                    try await screenshotsCache.add(
                        .init(id: app.id, screenshots: appScreenshots.map({ .init(url: $0.url, size: $0.size) }))
                    )
                    return appScreenshots
                } catch {
                    return []
                }
            }
        }
        
        private func fetchScreenshots(urls: [URL]) async throws -> [AppDetailScreenshots.Screenshot] {
            try await withThrowingTaskGroup(of: AppDetailScreenshots.Screenshot?.self) { group in
                var screenshots: [AppDetailScreenshots.Screenshot] = []
                for url in urls {
                    group.addTask {
                        do {
                            let size = try await self.imageSizeFetcher
                                .fetchSize(
                                    url: url,
                                    preferredWidth: AppDetailScreenshots.preferredWidth,
                                    maxHeight: AppDetailScreenshots.maxHeight
                                )
                            return (url: url, size: size)
                        } catch {
                            return nil
                        }
                    }
                }
                for try await screenshot in group {
                    if let screenshot {
                        screenshots.append(screenshot)
                    }
                }
                return screenshots.sorted(like: urls, keyPath: \.url)
            }
        }
        
        private func calculateAverageColorBrightnessVariants() {
            guard let appIconAverageColor else { return }
            
            if appIconAverageColor.brightness >= 0.85 {
                increasedBrightnessAverageColor = appIconAverageColor
            } else {
                let newBrightness = 1.9 - appIconAverageColor.brightness
                increasedBrightnessAverageColor = appIconAverageColor.colorWithBrightness(brightness: newBrightness)
            }
            
            if appIconAverageColor.brightness <= 0.55 {
                decreasedBrightnessAverageColor = appIconAverageColor
            } else {
                decreasedBrightnessAverageColor = appIconAverageColor.colorWithBrightness(brightness: 0.55)
            }
            
            logger.log(.debug, "calculateAverageColorBrightnessVariants")
        }
        
        var scrollOffset: CGFloat = .zero {
            didSet {
                hasScrolledPastNavigationBar = scrollOffset < -140
            }
        }
    }
}

struct AppDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let _ = Dependencies.screenshotsCache.register { .mock }
            let _ = Dependencies.imageSizeFetcher.register { .mock(returning: .init(width: 180, height: 320)) }
            
            // Preview with mocked app
            let _ = Dependencies.apiService.register { .mock(.data([App.mock])) }
            let viewModel = AppDetailView.ViewModel(id: "1", type: .ios)
            AppDetailView(viewModel: viewModel)
                .previewDisplayName("Mocked")
            
            // Preview with error
            let _ = Dependencies.apiService.register { .mock(.error(.example)) }
            let viewModel2 = AppDetailView.ViewModel(id: "1", type: .ios)
            AppDetailView(viewModel: viewModel2)
                .previewDisplayName("Error")
            
            // Preview while loading
            let _ = Dependencies.apiService.register { .mock(.loading()) }
            let viewModel3 = AppDetailView.ViewModel(id: "1", type: .ios)
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
