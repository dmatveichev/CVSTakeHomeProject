//
//  CVSTakeHomeProjectTests.swift
//  CVSTakeHomeProjectTests
//
//  Created by Dmitry Matveichev on 11/26/24.
//

import XCTest
import Foundation

@testable import CVSTakeHomeProject

final class FetchServiceTests: XCTestCase {
    var mockSession: MockURLSession!
    var fetchService: FetchService!
    
    let sampleResponse = FlickrPhotoResponse(
        title: "Sample Title",
        link: "https://example.com",
        description: "",
        modified: "2024-11-21T13:29:08Z",
        generator: "https://example.com",
        items: [
            FlickrPhoto(
                title: "Photo 1",
                link: "https://example.com/photo1",
                media: Media(m: "https://example.com/photo.jpg"),
                dateTaken: "2024-11-21T13:29:08Z",
                description: "Sample Description",
                published: "2024-11-21T13:29:08Z",
                author: "Author Name",
                authorId: "123",
                tags: "sample,tags"
            )
        ]
    )

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        fetchService = FetchService(session: mockSession)
    }

    override func tearDown() {
        mockSession = nil
        fetchService = nil
        super.tearDown()
    }

    func testFetchItemsSuccess() async throws {
        let responseData = try JSONEncoder().encode(sampleResponse)
        mockSession.data = responseData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        let result = try await fetchService.fetchItems(with: "")

        XCTAssertEqual(result.title, "Sample Title")
        XCTAssertEqual(result.items.count, 1)
        XCTAssertEqual(result.items[0].title, "Photo 1")
    }

    func testFetchItemsInvalidResponse() async {
        mockSession.data = Data()
        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)

        do {
            _ = try await fetchService.fetchItems(with: "test")
            XCTFail("Expected FetchError.invalidResponse but no error was thrown")
        } catch let error as FetchError {
            XCTAssertEqual(error, .invalidResponse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchItemsDecodingError() async {
        mockSession.data = Data() // Invalid JSON data
        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        do {
            _ = try await fetchService.fetchItems(with: "test")
            XCTFail("Expected FetchError.invalidData but no error was thrown")
        } catch let error as FetchError {
            XCTAssertEqual(error, .invalidData)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchItemsWithINvalidSearchTerm() async throws {
        let responseData = try JSONEncoder().encode(sampleResponse)
        mockSession.data = responseData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        let result = try await fetchService.fetchItems(with: "%%%%123%%%%")

        XCTAssertEqual(result.items.count, 1)
        XCTAssertEqual(result.items[0].title, "Photo 1")
    }
}
