//
//  MockLocationManager.swift
//  ISSUtilityTests
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import CoreLocation
@testable import ISSUtility

class MockLocationManager: LocationManager {
	var locationManagerDelegate: LocationManagerDelegate?
	
	var desiredAccuracy: CLLocationAccuracy = 100
	
	var locationToReturn: CLLocation?
	func requestLocation() {
		guard let location = locationToReturn else { return }
		locationManagerDelegate?.customLocationManager(self, didUpdateLocations: [location])
	}
	
	var delegate: CLLocationManagerDelegate?
	
	private(set) var requestWhenInUseAuthorizationCallCount: Int = 0
	func requestWhenInUseAuthorization() {
		 requestWhenInUseAuthorizationCallCount += 1
	}
	
	func getAuthorizationStatus() -> CLAuthorizationStatus {
		return .authorizedWhenInUse
	}
}
