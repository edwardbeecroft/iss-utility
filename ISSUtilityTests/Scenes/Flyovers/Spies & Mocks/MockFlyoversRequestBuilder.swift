//
//  MockFlyoversRequestBuilder.swift
//  ISSUtilityTests
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ISSUtility

class MockFlyoversRequestBuilder: FlyoversRequestBuilderProtocol {
	private(set) var preparedCoordinates: CLLocationCoordinate2D?
	private(set) var mockedFlyoversRequests = [CLLocationCoordinate2D: URLRequest]()
	func set(_ request: URLRequest, with coordinates: CLLocationCoordinate2D) {
		mockedFlyoversRequests[coordinates] = request
	}
	func prepareFlyoversRequestForCoordinates(_ coordinates: CLLocationCoordinate2D) -> URLRequest? {
		preparedCoordinates = coordinates
		return mockedFlyoversRequests[coordinates] ?? URLRequest(url: URL(string: "http://not-found.com")!)
	}
}
