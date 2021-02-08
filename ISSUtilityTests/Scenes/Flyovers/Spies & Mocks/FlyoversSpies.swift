//
//  FlyoversSpies.swift
//  ISSUtilityTests
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ISSUtility

class FlyoversViewSpy: FlyoversViewProtocol {
	private(set) var capturedDisplayedViewModels: [FlyoversViewModel] = []
	func display(viewModel: FlyoversViewModel) {
		capturedDisplayedViewModels.append(viewModel)
	}
	
	private(set) var capturedDisplayLoadingIndicatorMessages: [Bool] = []
	func displayLoadingIndicator(display: Bool) {
		capturedDisplayLoadingIndicatorMessages.append(display)
	}
	
	private(set) var displayLocationPermissionsRequiredAlertCallCount: Int = 0
	func displayLocationPermissionsRequiredAlert() {
		displayLocationPermissionsRequiredAlertCallCount += 1
	}
	
	private(set) var displayLocationFetchFailedAlertCallCount: Int = 0
	func displayLocationFetchFailedAlert() {
		displayLocationFetchFailedAlertCallCount += 1
	}
	
	private(set) var displayFlyoverFetchFailedAlertCallCount: Int = 0
	func displayFlyoverFetchFailedAlert() {
		displayFlyoverFetchFailedAlertCallCount += 1
	}
	
	private(set) var displayNoConnectivityAlertCallCount: Int = 0
	func displayNoConnectivityAlert() {
		displayNoConnectivityAlertCallCount += 1
	}
}

class FlyoversPresenterSpy: FlyoversPresenterProtocol {
	private(set) var onViewDidLoadCallCount: Int = 0
	func onViewDidLoad() {
		onViewDidLoadCallCount += 1
	}
	
	private(set) var onTappedRetryGetLocationCallCount: Int = 0
	func onTappedRetryGetLocation() {
		onTappedRetryGetLocationCallCount += 1
	}
	
	private(set) var onTappedRetryNotNowCallCount: Int = 0
	func onTappedRetryNotNow() {
		onTappedRetryNotNowCallCount += 1
	}
	
	private(set) var onTappedBackCallCount: Int = 0
	func onTappedBack() {
		onTappedBackCallCount += 1
	}
}

class FlyoversRouterSpy: FlyoversRouterProtocol {
	private(set) var popFlyoversViewCallCount: Int = 0
	func popFlyoversView() {
		popFlyoversViewCallCount += 1
	}
}

class FlyoversInteractorSpy: FlyoversInteractorProtocol {
	typealias Message = (coordinates: CLLocationCoordinate2D, completion: (FlyoversFetchResult) -> Void)
	private(set) var capturedMessages: [Message] = []
	func fetchFlyoversForCoordinates(coordinates: CLLocationCoordinate2D, completion: @escaping (FlyoversFetchResult) -> Void) {
		capturedMessages.append((coordinates: coordinates, completion: completion))
	}
}
