//
//  FlyoversRequestBuilder.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import CoreLocation

// MARK: - FlyoversRequestBuilderProtocol

class FlyoversRequestBuilder: FlyoversRequestBuilderProtocol {
	func prepareFlyoversRequestForCoordinates(_ coordinates: CLLocationCoordinate2D) -> URLRequest? {
		guard let url = Endpoint.flyovers(lat: coordinates.latitude,
										  long: coordinates.longitude).url() else {
			return nil
		}
		var request = URLRequest(url: url)
		request.httpMethod = HTTPMethod.get.rawValue
		return request
	}
}
