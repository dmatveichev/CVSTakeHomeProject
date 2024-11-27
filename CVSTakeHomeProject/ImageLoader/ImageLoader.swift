//
//  ImageLoader.swift
//  CVSTakeHomeProject
//
//  Created by Dmitry Matveichev on 11/26/24.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private var cancellable: AnyCancellable?
    private let url: URL
    private var cache: ImageCache?

    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }

    func load() {
        if let cachedImage = cache?[url] {
            self.image = cachedImage
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] downloadedImage in
                guard let self = self else { return }
                self.image = downloadedImage
                if let downloadedImage = downloadedImage {
                    self.cache?[self.url] = downloadedImage
                }
            }
    }

    func cancel() {
        cancellable?.cancel()
    }
}
