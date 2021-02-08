//
//  ISSLocationRequestBuilder.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import Foundation

// MARK: - ISSLocationRequestBuilderProtocol

class ISSLocationRequestBuilder: ISSLocationRequestBuilderProtocol {
	func prepareISSLocationRequest() -> URLRequest? {
		guard let url = Endpoint.location.url() else { return nil }
		var request = URLRequest(url: url)
		request.httpMethod = HTTPMethod.get.rawValue
		return request
	}
}
