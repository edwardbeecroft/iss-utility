//
//  FlyoversRequestBuilderTests.swift
//  ISSUtilityTests
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ISSUtility

class FlyoversRequestBuilderTests: XCTestCase {
	func testPrepareFlyoversRequestForCoordinatesConstructsCorrectRequest() {
		let testCoordinates = CLLocationCoordinate2D(latitude: 10, longitude: 10)

		let sut = FlyoversRequestBuilder()
		guard let request = sut.prepareFlyoversRequestForCoordinates(testCoordinates) else {
			return XCTFail("Expected valid URLRequest")
		}

		XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
		XCTAssertEqual(request.url?.absoluteString, "http://api.open-notify.org/iss-pass.json?lat=10.0&lon=10.0&n=5")
	}
}
