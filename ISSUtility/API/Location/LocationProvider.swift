//
//  LocationProvider.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import CoreLocation

enum GetLocationOutcome {
	case success(CLLocation)
	case unauthorized
	case error
}

protocol LocationProviderProtocol: AnyObject {
	var locationManager: LocationManager { get set }
	init(locationManager: LocationManager)
	func getCurrentLocation(completion: @escaping (GetLocationOutcome) -> Void)
}

final class LocationProvider: NSObject {
    
	// MARK: - Properties
	
	private var currentLocationCallback: ((GetLocationOutcome) -> Void)?
    var locationManager: LocationManager
	
	// MARK: - Lifecycle
	
    init(locationManager: LocationManager = CLLocationManager()) {
    	self.locationManager = locationManager
    	super.init()
    	configureLocationManager()
    }
	
	// MARK: - Configure Location Manager
	
	private func configureLocationManager() {
		locationManager.locationManagerDelegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
	}
}

// MARK: - Lifecycle

extension LocationProvider: LocationProviderProtocol {
	func getCurrentLocation(completion: @escaping (GetLocationOutcome) -> Void) {
		
		currentLocationCallback = { outcome in
			completion(outcome)
		}
		
		handleLocationUpdate()
	}
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		handleLocationUpdate()
	}
	
	private func handleLocationUpdate() {
		switch locationManager.getAuthorizationStatus() {
		case .notDetermined:
			locationManager.requestWhenInUseAuthorization()
		case .restricted, .denied:
			currentLocationCallback?(.unauthorized)
		case .authorizedAlways,
			 .authorizedWhenInUse:
			locationManager.requestLocation()
		@unknown default:
			// 'CLAuthorizationStatus' may have additional unknown values, possibly added in future versions
			break
		}
	}
}

// MARK: - LocationManagerDelegate

extension LocationProvider: LocationManagerDelegate {
	func customLocationManager(_ manager: LocationManager, didFailWithError error: Error) {
		currentLocationCallback?(.error)
	}
	
	func customLocationManager(_ manager: LocationManager, didUpdateLocations locations: [CLLocation]) {
		logLocationsIfSimulator(locations)
		if let location = locations.first {
			currentLocationCallback?(.success(location))
		} else {
			currentLocationCallback?(.error)
		}
    	currentLocationCallback = nil
	}
}

// MARK: - CLLocationManagerDelegate

extension LocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		customLocationManager(manager, didUpdateLocations: locations)
    }
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		customLocationManager(manager, didFailWithError: error)
	}
}

// MARK: - Debug Logging

private extension LocationProvider {
	func logLocationsIfSimulator(_ locations: [CLLocation]) {
		#if targetEnvironment(simulator)
		print("***** DEBUG: USER LOCATIONS *****")
		locations.forEach({
			print("Location: \($0)")
		})
		#endif
	}
}
