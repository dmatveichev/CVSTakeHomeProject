//
//  CachedAsyncImage.swift
//  CVSTakeHomeProject
//
//  Created by Dmitry Matveichev on 11/26/24.
//

import SwiftUI

struct CachedAsyncImage: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Image

    init(
        url: URL,
        cache: ImageCache? = nil,
        placeholder: Image = Image(systemName: "photo")
    ) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: cache))
        self.placeholder = placeholder
    }

    var body: some View {
        content
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }

    private var content: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                placeholder
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}
