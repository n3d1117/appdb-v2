//
//  Dependencies.swift
//  appdb
//
//  Created by ned on 08/01/23.
//

import Factory

typealias Dependencies = Container
typealias Dependency = Injected

extension Dependencies {
    static let logger = Factory(scope: .shared) { Logger() }
    static let apiService = Factory(scope: .shared) { APIService() }
    static let imageSizeFetcher = Factory(scope: .shared) { ImageSizeFetcher() }
    static let screenshotsCache = Factory(scope: .shared) { ScreenshotsCacheService() }
}
