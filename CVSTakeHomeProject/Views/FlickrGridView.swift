//
//  FlickrGridView.swift
//  CVSTakeHomeProject
//
//  Created by Dmitry Matveichev on 11/26/24.
//

import SwiftUI

struct FlickrGridView: View {
    @StateObject private var viewModel = FlickrPhotoViewModel()
    @Environment(\.imageCache) private var cache

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchTerm)
                
                ZStack {
                    if viewModel.isLoading {
                        VStack {
                            ProgressView("Loading...")
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                                if viewModel.photos.isEmpty {
                                    VStack {
                                        Text("No results found")
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                } else {
                                    ForEach(viewModel.photos) { photo in
                                        NavigationLink(destination: ImageDetailView(photo: photo)) {
                                            VStack {
                                                if let url = URL(string: photo.media.m) {
                                                    CachedAsyncImage(url: url, cache: cache)
                                                        .frame(width: 100, height: 100)
                                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                                }
                                                
                                                Text(photo.title)
                                                    .font(.caption)
                                                    .lineLimit(1)
                                                    .foregroundColor(.black)
                                            }
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Flickr Photos")
            .onAppear {
                viewModel.fetchPhotos()
            }
        }
    }
}
