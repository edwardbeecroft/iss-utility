//
//  MockLocationProvider.swift
//  ISSUtilityTests
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import CoreLocation
import XCTest
@testable import ISSUtility

final class MockLocationProvider: LocationProviderProtocol {
	var locationManager: LocationManager
	
	init(locationManager: LocationManager = MockLocationManager()) {
		self.locationManager = locationManager
	}
	
	private(set) var getCurrentLocationCallCount: Int = 0
    private(set) var capturedCompletions = [(GetLocationOutcome) -> Void]()
	func getCurrentLocation(completion: @escaping (GetLocationOutcome) -> Void) {
		getCurrentLocationCallCount += 1
		capturedCompletions.append(completion)
	}
}
