//
//  ImageSizeFetcher.swift
//  appdb
//
//  Created by ned on 11/01/23.
//

import UIKit

class ImageSizeFetcher {
    let networking: Networking
    
    init(networking: Networking = URLSession.shared) {
        self.networking = networking
    }

    func fetchSize(url: URL, preferredWidth: (portrait: CGFloat, landscape: CGFloat), maxHeight: CGFloat) async throws -> CGSize {
        let proposedSize: CGSize
        
        do {
            switch try ImageType.fromURL(url) {
            case .png: proposedSize = try await getPNGImageSize(url)
            case .jpg: proposedSize = try await getJPGImageSize(url)
            }
        } catch {
            proposedSize = try await getImageSize(url)
        }
        
        var convertedSize: CGSize = .zero
        convertedSize.width = proposedSize.width > proposedSize.height ? preferredWidth.landscape : preferredWidth.portrait
        convertedSize.height = min((proposedSize.height * convertedSize.width) / proposedSize.width, maxHeight)
        return convertedSize
    }
    
    private func getImageSize(_ url: URL) async throws -> CGSize {
        let (data, _) = try await networking.data(for: URLRequest(url: url))
        guard let image = UIImage(data: data) else {
            throw FetchError.unexpectedData
        }
        return image.size
    }
    
    private func getPNGImageSize(_ url: URL) async throws -> CGSize {
        var request: URLRequest = URLRequest(url: url)
        request.setValue("bytes=16-23", forHTTPHeaderField: "Range")
        let (data, _) = try await networking.data(for: request)
        guard data.count == 8 else { throw FetchError.unexpectedData }
        
        var w1: Int = 0
        var w2: Int = 0
        var w3: Int = 0
        var w4: Int = 0
        (data as NSData).getBytes(&w1, range: NSMakeRange(0, 1))
        (data as NSData).getBytes(&w2, range: NSMakeRange(1, 1))
        (data as NSData).getBytes(&w3, range: NSMakeRange(2, 1))
        (data as NSData).getBytes(&w4, range: NSMakeRange(3, 1))
        
        let w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4
        var h1: Int = 0
        var h2: Int = 0
        var h3: Int = 0
        var h4: Int = 0
        (data as NSData).getBytes(&h1, range: NSMakeRange(4, 1))
        (data as NSData).getBytes(&h2, range: NSMakeRange(5, 1))
        (data as NSData).getBytes(&h3, range: NSMakeRange(6, 1))
        (data as NSData).getBytes(&h4, range: NSMakeRange(7, 1))
        let h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4
        
        return CGSize(width: CGFloat(w), height: CGFloat(h))
    }
    
    private func getJPGImageSize(_ url: URL) async throws -> CGSize {
        var request = URLRequest(url: url)
        request.setValue("bytes=0-209", forHTTPHeaderField: "Range")
        let (data, _) = try await networking.data(for: request)
        guard data.count > 0x58 else { throw FetchError.unexpectedData }

        if data.count < 210 {
            var w1: Int = 0
            var w2: Int = 0
            
            (data as NSData).getBytes(&w1, range: NSMakeRange(0x60, 0x1))
            (data as NSData).getBytes(&w2, range: NSMakeRange(0x61, 0x1))
            
            let w = (w1 << 8) + w2
            var h1: Int = 0
            var h2: Int = 0
            
            (data as NSData).getBytes(&h1, range: NSMakeRange(0x5e, 0x1))
            (data as NSData).getBytes(&h2, range: NSMakeRange(0x5f, 0x1))
            let h = (h1 << 8) + h2
            
            return CGSize(width: CGFloat(w), height: CGFloat(h))
            
        } else {
            var word = 0x0
            
            (data as NSData).getBytes(&word, range: NSMakeRange(0x15, 0x1))
            guard word == 0xdb else { throw FetchError.unexpectedData }
            
            (data as NSData).getBytes(&word, range: NSMakeRange(0x5a, 0x1))
            
            if word == 0xdb {
                var w1: Int = 0
                var w2: Int = 0
                
                (data as NSData).getBytes(&w1, range: NSMakeRange(0xa5, 0x1))
                (data as NSData).getBytes(&w2, range: NSMakeRange(0xa6, 0x1))
                
                let w = (w1 << 8) + w2
                var h1: Int = 0
                var h2: Int = 0
                
                (data as NSData).getBytes(&h1, range: NSMakeRange(0xa3, 0x1))
                (data as NSData).getBytes(&h2, range: NSMakeRange(0xa4, 0x1))
                let h = (h1 << 8) + h2
                
                return CGSize(width: CGFloat(w), height: CGFloat(h))
            } else {
                var w1: Int = 0
                var w2: Int = 0
                
                (data as NSData).getBytes(&w1, range: NSMakeRange(0x60, 0x1))
                (data as NSData).getBytes(&w2, range: NSMakeRange(0x61, 0x1))
                
                let w = (w1 << 8) + w2
                var h1: Int = 0
                var h2: Int = 0
                
                (data as NSData).getBytes(&h1, range: NSMakeRange(0x5e, 0x1))
                (data as NSData).getBytes(&h2, range: NSMakeRange(0x5f, 0x1))
                let h = (h1 << 8) + h2
                
                return CGSize(width: CGFloat(w), height: CGFloat(h))
            }
        }
    }
}

private extension ImageSizeFetcher {
    private enum ImageType {
        case png, jpg
        
        static func fromURL(_ url: URL) throws -> Self {
            switch url.pathExtension.lowercased() {
            case "png": return .png
            case "jpg", "jpeg": return .jpg
            default:
                throw FetchError.unknownExtension
            }
        }
    }
}

private extension ImageSizeFetcher {
    enum FetchError: String, LocalizedError {
        case unknownExtension = "Unknown extension"
        case unexpectedData = "Unexpected data count"
        
        public var errorDescription: String? { rawValue }
    }
}

#if DEBUG
extension ImageSizeFetcher {
    private class ImageSizeFetcherMock: ImageSizeFetcher {
        let mockedSize: CGSize
        
        init(mockedSize: CGSize) {
            self.mockedSize = mockedSize
        }
        
        override func fetchSize(url: URL, preferredWidth: (portrait: CGFloat, landscape: CGFloat), maxHeight: CGFloat) async throws -> CGSize {
            mockedSize
        }
    }
    
    static func mock(returning mockedSize: CGSize) -> ImageSizeFetcher {
        ImageSizeFetcherMock(mockedSize: mockedSize)
    }
}
#endif
