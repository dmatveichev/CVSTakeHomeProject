/*
Project Structure:
Folder:
- FileName // Description
*/

Entities:
- FlickrPhoto // structure to represent photo data from https://api.flickr.com
- FlickrPhotoResponse // structure to represent responce from URL, containing Array of FlickrPhoto items
Networking:
- FetchService // Responsible for fetching JSON data from https://api.flickr.com and converting to FlickrPhotoResponse
Helpers:
- HTMLWebView // Used to represent HTML description on the DetailView
ImageLoader:
- ImageLoader // Used to download image from URL and store to cache using Combine
- ImageCache // Used to store already downloaded image data
- ImageCacheKey // Used to setup @Environment variable for SwiftUI views
Mocks:
- MockURLSession // Used to mock URLSession for XCTests
Protocols:
- URLSessionProtocol
- FetchServiceProtocol
ViewModels:
- FlickrPhotoViewModel // View Model for main screen with grid view (FlickrGridView). Provide requests to FetchService and return data to View.
Views:
- FlickrGridView // Main view to present SearchBar and GridView
- ImageDetailView // Secondary view to represent image details and other information. Added Share button as well
- SearchBar // Search bar for Main View
- CachedAsyncImage // SwiftUI view to present image from ImageLoader (download or from cache)
- ShareButton // Share button for ImageDetailView
CVSTakeHomeProjectTests:
- FetchServiceTests // XCTests for FetchService
