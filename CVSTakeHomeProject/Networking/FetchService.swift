//
//  FetchService.swift
//  CVSTakeHomeProject
//
//  Created by Dmitry Matveichev on 11/26/24.
//

import Foundation

extension URLSession: URLSessionProtocol {}

class FetchService: FetchServiceProtocol {
    private let session: URLSessionProtocol
    private let baseURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags="
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetchItems(with searchTerm: String = "") async throws -> FlickrPhotoResponse {
        guard let encodedTags = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)\(encodedTags)") else {
            throw FetchError.invalidURL
        }
        let (data, response) = try await session.data(from: url)
        
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            throw FetchError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(FlickrPhotoResponse.self, from: data)
            return response
        } catch {
            print("Decoding Error: \(error)")
            throw FetchError.invalidData
        }
    }
}

enum FetchError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid Response."
        case .invalidData:
            return "Invalid JSON Data."
        }
    }
}
