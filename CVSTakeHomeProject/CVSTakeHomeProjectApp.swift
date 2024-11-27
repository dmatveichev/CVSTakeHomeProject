//
//  CVSTakeHomeProjectApp.swift
//  CVSTakeHomeProject
//
//  Created by Dmitry Matveichev on 11/26/24.
//

import SwiftUI

@main
struct CVSTakeHomeProjectApp: App {
    private let imageCache = TemporaryImageCache()
    
    var body: some Scene {
        WindowGroup {
            FlickrGridView()
                .environment(\.imageCache, imageCache)
        }
    }
}
