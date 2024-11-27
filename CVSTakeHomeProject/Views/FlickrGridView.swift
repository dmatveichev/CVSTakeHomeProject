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
    
    @Namespace private var namespace
    @State var selectedPhoto: FlickrPhoto?

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
                        if viewModel.photos.isEmpty {
                            VStack {
                                if let errorMessage = viewModel.errorMessage {
                                    Text(errorMessage)
                                        .foregroundColor(.red)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                } else {
                                    Text("No results found")
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ScrollView {
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                                    ForEach(viewModel.photos) { photo in
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
                                        .onTapGesture {
                                            selectedPhoto = photo
                                        }
                                        .matchedTransitionSource(id: photo.id, in: namespace)
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
            .sheet(item: $selectedPhoto) { photo in
                ImageDetailView(photo: photo)
                    .navigationTransition(.zoom(sourceID: photo.id, in: namespace))
            }
        }
    }
}
