//
//  Protocols.swift
//  CVSTakeHomeProject
//
//  Created by Dmitry Matveichev on 11/26/24.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

protocol FetchServiceProtocol {
    func fetchItems(with searchTerm: String) async throws -> FlickrPhotoResponse
}
