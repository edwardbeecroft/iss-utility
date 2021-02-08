//
//  FlyoversInteractorTests.swift
//  ISSUtilityTests
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ISSUtility

class FlyoversInteractorTests: XCTestCase {
	
	private let testCoordinates = CLLocationCoordinate2D(latitude: 10, longitude: 10)
	
	// MARK: - API Tests
	
	func testFetchFlyoversForCoordinatesCallsAPIClient() {
		let api = APIClientSpy()
		let sut = makeSUT(api: api)
		
		XCTAssertEqual(api.capturedMessages.count, 0)
		
		sut.fetchFlyoversForCoordinates(coordinates: testCoordinates, completion: { result in })
		
		XCTAssertEqual(api.capturedMessages.count, 1)
	}
	
	func testFetchFlyoversWithAPISuccessAndValidResponseCompletesWithSuccess() {
		let api = APIClientSpy()
		let sut = makeSUT(api: api)
		
		let validResponse: Any = ["message": "success", "response": [["duration": 100, "risetime": 100]]]
		
		let exp = expectation(description: "Wait for API")
		
		sut.fetchFlyoversForCoordinates(coordinates: testCoordinates) { result in
			switch result {
			case .success:
				exp.fulfill()
			default:
				XCTFail("Expected success.")
			}
		}
		api.capturedMessages.first?.completion(validResponse, nil)
		
		wait(for: [exp], timeout: 0.3)
	}
	
	func testFetchFlyoversWithAPISuccessButInvalidCompletesWithParsingFailure() {
		let api = APIClientSpy()
		let sut = makeSUT(api: api)
		
		let invalidResponse: Any = ["message": "success", "response": ["duration": 100, "risetime": 100]]
		
		let exp = expectation(description: "Wait for API")
		
		sut.fetchFlyoversForCoordinates(coordinates: testCoordinates) { result in
			switch result {
			case .failure(let error):
				XCTAssertEqual(error, .parsing)
				exp.fulfill()
			default:
				XCTFail("Expected failure.")
			}
		}
		api.capturedMessages.first?.completion(invalidResponse, nil)
		
		wait(for: [exp], timeout: 0.3)
	}
	
	func testFetchFlyoversWithAPIErrorCompletesWithGeneralFailure() {
		let api = APIClientSpy()
		let sut = makeSUT(api: api)
		
		let exp = expectation(description: "Wait for API")
		
		sut.fetchFlyoversForCoordinates(coordinates: testCoordinates) { result in
			switch result {
			case .failure(let error):
				XCTAssertEqual(error, .general)
				exp.fulfill()
			default:
				XCTFail("Expected failure.")
			}
		}
		api.capturedMessages.first?.completion(nil, NSError.generic)
		
		wait(for: [exp], timeout: 0.3)
	}
	
	// MARK: - Request Builder Tests
	
	func testFetchFlyoversForCoordinatesBuildsARequest() {
		let requestBuilder = MockFlyoversRequestBuilder()
		let sut = makeSUT(requestBuilder: requestBuilder)
	
		XCTAssertEqual(requestBuilder.preparedCoordinates, nil)
		XCTAssertNil(requestBuilder.mockedFlyoversRequests[testCoordinates])
		
		let testRequest = URLRequest(url: URL(string: "https://google.com")!)
		requestBuilder.set(testRequest, with: testCoordinates)
		
		sut.fetchFlyoversForCoordinates(coordinates: testCoordinates, completion: { result in })
		
		XCTAssertEqual(requestBuilder.preparedCoordinates, testCoordinates)
		XCTAssertNotNil(requestBuilder.mockedFlyoversRequests[testCoordinates])
	}
	
	// MARK: - Helpers
	
	private func makeSUT(api: API = APIClientSpy(),
						 requestBuilder: FlyoversRequestBuilderProtocol = MockFlyoversRequestBuilder(),
						 parser: Parser = MockResponseParser()) -> FlyoversInteractor {
		let interactor = FlyoversInteractor(api: api,
											requestBuilder: requestBuilder,
											parser: parser)
		return interactor
	}
}
