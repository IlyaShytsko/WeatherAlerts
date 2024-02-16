//
//  WeatherAlertsTests.swift
//  WeatherAlertsTests
//
//  Created by Ilya Shytsko on 13.02.24.
//

import XCTest
@testable import WeatherAlerts

import UIKit

enum MockError: Error {
    case testError
}

class MockApiClient: ApiClientProtocol {
    var mockModelResponse: Decodable?
    var mockImageResponse: UIImage?
    var mockError: Error?

    func request<Model>(_ route: ApiRouter) async throws -> Model where Model: Decodable {
        if let error = mockError {
            throw error
        }

        guard let response = mockModelResponse as? Model else {
            throw MockError.testError
        }

        return response
    }

    func fetchRandomImage() async throws -> UIImage? {
        if let error = mockError {
            throw error
        }
        return mockImageResponse
    }
}

final class ApiClientTest: XCTestCase {

    func testFetchRequestFailure() async {
        let mockApiClient = MockApiClient()
        mockApiClient.mockError = MockError.testError

        do {
            let _ = try await mockApiClient.request(.alertRequest) as WeatherAlertsModel
            XCTFail("An error was expected, but execution continued")
        } catch {
            XCTAssertEqual(error as? MockError, MockError.testError, "Ожидалась ошибка testError")
        }
    }

    func testFetchRandomImageSuccess() async {
        let mockApiClient = MockApiClient()
        mockApiClient.mockImageResponse = UIImage()

        do {
            let image = try await mockApiClient.fetchRandomImage()
            XCTAssertNotNil(image, "The image must be obtained")
        } catch {
            XCTFail("Error while acquiring an image: \(error)")
        }
    }

}
