//
//  ScreenshotsCacheService.swift
//  appdb
//
//  Created by ned on 14/01/23.
//

import Foundation
import Bodega

class ScreenshotsCacheService {
    let storage: ObjectStorage<AppScreenshotsCache>
    
    init(storage: ObjectStorage<AppScreenshotsCache>) {
        self.storage = storage
    }
    
    init() {
        let storageEngine = SQLiteStorageEngine.default(appendingPath: "Screenshots")
        self.storage = .init(storage: storageEngine)
    }
    
    func add(_ screenshot: AppScreenshotsCache) async throws {
        try await storage.store(screenshot, forKey: CacheKey(String(screenshot.id)))
    }
    
    func first(for id: Int) async -> [Screenshot]? {
        await storage.object(forKey: CacheKey(String(id)))?.screenshots
    }
}

extension ScreenshotsCacheService {
    struct AppScreenshotsCache: Codable, Equatable, Identifiable {
        let id: Int
        let screenshots: [Screenshot]
    }
    
    struct Screenshot: Codable, Equatable {
        let url: URL
        let size: CGSize
        
        var id: String { CacheKey(url: url).value }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}

#if DEBUG
extension ScreenshotsCacheService {
    private class PersistenceServiceMock: ScreenshotsCacheService {
        override init() {
            let mockEngine = SQLiteStorageEngine(directory: .temporary(appendingPath: "Mocks"))!
            super.init(storage: .init(storage: mockEngine))
        }
        
        override func add(_ screenshot: ScreenshotsCacheService.AppScreenshotsCache) async throws {
            // no-op
        }
        
        override func first(for id: Int) async -> [ScreenshotsCacheService.Screenshot]? {
            nil
        }
    }
    
    static let mock: ScreenshotsCacheService = PersistenceServiceMock()
}
#endif
