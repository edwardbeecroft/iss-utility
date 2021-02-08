//
//  SharedInterfaces.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import CoreLocation

protocol RouterProtocol: AnyObject {
	var childRouters: [RouterProtocol] { get set }
	func childDidFinish(_ child: RouterProtocol)
	func start()
}

extension RouterProtocol {
	func childDidFinish(_ child: RouterProtocol) {
		childRouters.removeAll(where: { $0 === child })
	}
}

protocol LocationManager {
	var locationManagerDelegate: LocationManagerDelegate? { get set }
	var desiredAccuracy: CLLocationAccuracy { get set }
    func requestWhenInUseAuthorization()
	func requestLocation()
	func getAuthorizationStatus() -> CLAuthorizationStatus
}

extension CLLocationManager: LocationManager {
	func getAuthorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
	var locationManagerDelegate: LocationManagerDelegate? {
		get { return delegate as? LocationManagerDelegate? ?? nil }
    	set { delegate = newValue as? CLLocationManagerDelegate? ?? nil }
    }
}

protocol LocationManagerDelegate: class {
    func customLocationManager(_ manager: LocationManager, didUpdateLocations locations: [CLLocation])
	func customLocationManager(_ manager: LocationManager, didFailWithError error: Error)
}
