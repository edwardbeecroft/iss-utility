//
//  CLLocation+Extensions.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import CoreLocation

extension CLLocation {
	func geocode(completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
		CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
	}
}

extension CLLocationCoordinate2D: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(latitude.hashValue)
        hasher.combine(longitude.hashValue)
    }
	
	public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
		return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
	}
}

extension CLLocationCoordinate2D {
	func bearing(to point: CLLocationCoordinate2D) -> Double {
		let lat1 = Double(latitude).degreesToRadians
		let lon1 = Double(longitude).degreesToRadians
		
		let lat2 = Double(point.latitude).degreesToRadians
		let lon2 = Double(point.longitude).degreesToRadians
		
		let dLon = lon2 - lon1;
		
		let y = sin(dLon) * cos(lat2);
		let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
		let radiansBearing = atan2(y, x);
		return Double(radiansBearing).radiansToDegrees
	}
}
