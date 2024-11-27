//
//  FlickrPhotoViewModel.swift
//  CVSTakeHomeProject
//
//  Created by Dmitry Matveichev on 11/26/24.
//

import SwiftUI

class FlickrPhotoViewModel: ObservableObject {
    @Published var photos: [FlickrPhoto] = []
    @Published var searchTerm: String = "" {
        didSet {
            if searchTerm != oldValue {
                fetchPhotos()
            }
        }
    }
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let fetchService: FetchServiceProtocol

    init(fetchService: FetchServiceProtocol = FetchService()) {
        self.fetchService = fetchService
    }

    func fetchPhotos() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let response = try await fetchService.fetchItems(with: searchTerm)
                DispatchQueue.main.async {
                    self.photos = response.items
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
