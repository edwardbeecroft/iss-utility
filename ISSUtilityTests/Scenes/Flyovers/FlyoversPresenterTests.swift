//
//  FlyoversPresenterTests.swift
//  ISSUtilityTests
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ISSUtility

class FlyoversPresenterTests: XCTestCase {
	
	// MARK: - View Tests
	
	func testDisplayLoadingIndicatorTrueCalledOnAttemptLocationUpdate() {
		let view = FlyoversViewSpy()
		let sut = makeSUT(view: view)

		XCTAssertEqual(view.capturedDisplayLoadingIndicatorMessages.count, 0)

		sut.onViewDidLoad()

		XCTAssertEqual(view.capturedDisplayLoadingIndicatorMessages.count, 1)
		XCTAssertEqual(view.capturedDisplayLoadingIndicatorMessages.first, true)
	}
	
	func testLocationProviderUnauthorizedOutcomeCallsDisplayLocationPermissionsRequiredAlertOnView() {
		let view = FlyoversViewSpy()
		let locationProvider = MockLocationProvider()
		let sut = makeSUT(view: view,
						  locationProvider: locationProvider)

		XCTAssertEqual(view.capturedDisplayLoadingIndicatorMessages.count, 0)
		
		sut.onViewDidLoad()
		
		XCTAssertEqual(view.capturedDisplayLoadingIndicatorMessages.count, 1)
		XCTAssertEqual(view.capturedDisplayLoadingIndicatorMessages.first, true)
		
		locationProvider.capturedCompletions.first?(.unauthorized)

		XCTAssertEqual(view.displayLocationPermissionsRequiredAlertCallCount, 1)
		XCTAssertEqual(view.capturedDisplayLoadingIndicatorMessages.count, 2)
		XCTAssertEqual(view.capturedDisplayLoadingIndicatorMessages.last, false)
	}
	
	func testLocationProviderErrorOutcomeCallsDisplayLocationPermissionsRequiredAlertOnView() {
		let view = FlyoversViewSpy()
		let locationProvider = MockLocationProvider()
		let sut = makeSUT(view: view,
						  locationProvider: locationProvider)

		XCTAssertEqual(view.capturedDisplayLoadingIndicatorMessages.count, 0)
		
		sut.onViewDidLoad()
		
		XCTAssertEqual(view.capturedDisplayLoadingIndicatorMessages.count, 1)
		XCTAssertEqual(view.capturedDisplayLoadingIndicatorMessages.first, true)
		
		locationProvider.capturedCompletions.first?(.error)

		XCTAssertEqual(view.displayLocationFetchFailedAlertCallCount, 1)
		XCTAssertEqual(view.capturedDisplayLoadingIndicatorMessages.count, 2)
		XCTAssertEqual(view.capturedDisplayLoadingIndicatorMessages.last, false)
	}
	
	func testFetchFlyoversForCoordinatesWithSuccessResponseCallsViewCorrectly() {
		let view = FlyoversViewSpy()
		let interactor = FlyoversInteractorSpy()
		let sut = makeSUT(view: view,
						  interactor: interactor)

		let testLocationString = "25 Monument Street, London, ECR3 8BQ"
		let testCoordinates = CLLocationCoordinate2D(latitude: 10, longitude: 10)
		sut.fetchFlyoversForCoordinates(testCoordinates,
										locationString: testLocationString)

		XCTAssertEqual(view.capturedDisplayLoadingIndicatorMessages.count, 0)
		XCTAssertEqual(view.capturedDisplayedViewModels.count, 0)
		
		let validResponse = FlyoversFetchResponse(message: "success", flyovers: [Flyover(duration: 100, risetime: 100)])
		interactor.capturedMessages.first?.completion(.success(validResponse))
		
		let exp = XCTestExpectation(description: "Wait for async callback")
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { exp.fulfill() }
		wait(for: [exp], timeout: 5.0)
		
		XCTAssertEqual(view.capturedDisplayLoadingIndicatorMessages.count, 1)
		XCTAssertEqual(view.capturedDisplayLoadingIndicatorMessages.first, false)
		
		XCTAssertEqual(view.capturedDisplayedViewModels.count, 1)
		XCTAssertEqual(view.capturedDisplayedViewModels.first?.titleString, testLocationString)
	}
	
	func testFetchFlyoversForCoordinatesWithFailureResponseCallsViewCorrectly() {
		let view = FlyoversViewSpy()
		let interactor = FlyoversInteractorSpy()
		let sut = makeSUT(view: view,
						  interactor: interactor)

		let testCoordinates = CLLocationCoordinate2D(latitude: 10, longitude: 10)
		sut.fetchFlyoversForCoordinates(testCoordinates,
										locationString: "25 Monument Street, London, ECR3 8BQ")

		XCTAssertEqual(view.capturedDisplayLoadingIndicatorMessages.count, 0)
		
		let validResponse = FlyoversFetchResponse(message: "success", flyovers: [Flyover(duration: 100, risetime: 100)])
		interactor.capturedMessages.first?.completion(.success(validResponse))
		
		let exp = XCTestExpectation(description: "Wait for async callback")
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { exp.fulfill() }
		wait(for: [exp], timeout: 5.0)
		
		XCTAssertEqual(view.capturedDisplayLoadingIndicatorMessages.count, 1)
		XCTAssertEqual(view.capturedDisplayLoadingIndicatorMessages.first, false)
	}
	
	// MARK: - Location Provider Tests
	
	func testOnViewDidLoadCallsLocationProvider() {
		let locationProvider = MockLocationProvider()
		let sut = makeSUT(locationProvider: locationProvider)

		XCTAssertEqual(locationProvider.getCurrentLocationCallCount, 0)

		sut.onViewDidLoad()

		XCTAssertEqual(locationProvider.getCurrentLocationCallCount, 1)
	}
	
	// MARK: - Interactor Tests
	
	func testFetchFlyoversForCoordinatesCallsInteractorAfterGettingLocation() {
		let interactor = FlyoversInteractorSpy()
		let sut = makeSUT(interactor: interactor)

		XCTAssertEqual(interactor.capturedMessages.count, 0)

		let testCoordinates = CLLocationCoordinate2D(latitude: 10, longitude: 10)
		sut.fetchFlyoversForCoordinates(testCoordinates,
										locationString: "25 Monument Street, London, ECR3 8BQ")
		
		XCTAssertEqual(interactor.capturedMessages.count, 1)
		XCTAssertEqual(interactor.capturedMessages.first?.coordinates, testCoordinates)
	}
	
	// MARK: - Router Tests
	
	func testOnTappedBackCallsPopFlyoversViewOnRouter() {
		let router = FlyoversRouterSpy()
		let sut = makeSUT(router: router)
		
		XCTAssertEqual(router.popFlyoversViewCallCount, 0)
		
		sut.onTappedBack()
		
		XCTAssertEqual(router.popFlyoversViewCallCount, 1)
	}
	
	func testOnTappedRetryNotNowCallsPopFlyoversViewOnRouter() {
		let router = FlyoversRouterSpy()
		let sut = makeSUT(router: router)
		
		XCTAssertEqual(router.popFlyoversViewCallCount, 0)
		
		sut.onTappedRetryNotNow()
		
		XCTAssertEqual(router.popFlyoversViewCallCount, 1)
	}
	
	// MARK: - Helpers
	
	private func makeSUT(view: FlyoversViewProtocol = FlyoversViewSpy(),
						 interactor: FlyoversInteractorProtocol = FlyoversInteractorSpy(),
						 router: FlyoversRouterProtocol = FlyoversRouterSpy(),
						 locationProvider: LocationProviderProtocol = MockLocationProvider()) -> FlyoversPresenter {
		let presenter = FlyoversPresenter(view: view,
										  interactor: interactor,
										  router: router,
										  locationProvider: locationProvider)
		return presenter
	}
}
