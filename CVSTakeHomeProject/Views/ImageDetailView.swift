//
//  ImageDetailView.swift
//  CVSTakeHomeProject
//
//  Created by Dmitry Matveichev on 11/26/24.
//

import SwiftUI

struct ImageDetailView: View {
    let photo: FlickrPhoto

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let url = URL(string: photo.media.m) {
                    CachedAsyncImage(url: url)
                        .frame(maxWidth: .infinity, maxHeight: 500)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Text(photo.title)
                    .font(.headline)

                Text("Author: \(photo.author)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("Published: \(photo.formattedPublishedDate)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                VStack {
                    ShareLink(
                        item: URL(string: photo.media.m)!,
                        message: Text("Check out this photo: \(photo.title) by \(photo.author). Published on \(photo.formattedPublishedDate).")
                    ) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                HTMLWebView(htmlContent: photo.description)
                    .frame(height: 250)
            }
            .padding()
            .navigationTitle("Image Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
