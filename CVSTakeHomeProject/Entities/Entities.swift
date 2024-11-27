//
//  Entities.swift
//  CVSTakeHomeProject
//
//  Created by Dmitry Matveichev on 11/26/24.
//

import Foundation

struct FlickrPhoto: Codable, Identifiable {
    let id = UUID()
    let title: String
    let link: String
    let media: Media
    let dateTaken: String
    let description: String
    let published: String
    let author: String
    let authorId: String
    let tags: String

    private enum CodingKeys: String, CodingKey {
        case title, link, media, dateTaken, description, published, author, authorId, tags
    }
    
    var formattedPublishedDate: String {
        let formatter = ISO8601DateFormatter()
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short

        if let date = formatter.date(from: published) {
            return displayFormatter.string(from: date)
        } else {
            return "Unknown Date"
        }
    }
}


struct FlickrPhotoResponse: Codable {
    let title: String
    let link: String
    let description: String
    let modified: String
    let generator: String
    let items: [FlickrPhoto]
}

struct Media: Codable {
    let m: String
}
