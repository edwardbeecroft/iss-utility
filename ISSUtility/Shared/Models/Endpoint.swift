//
//  Endpoint.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import CoreLocation

enum Endpoint {
	case flyovers(lat: CLLocationDegrees, long: CLLocationDegrees)
	case location
	
	func url() -> URL? {
		switch self {
		case .flyovers(let lat, let long):
			return URL(string: "http://api.open-notify.org/iss-pass.json?lat=\(lat)&lon=\(long)&n=5")
		case .location:
			return URL(string: Endpoint.baseURL)
		}
	}
	
	private static let baseURL: String = "http://api.open-notify.org/iss-now.json"
}
