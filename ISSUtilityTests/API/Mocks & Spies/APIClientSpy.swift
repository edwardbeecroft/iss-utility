//
//  APIClientSpy.swift
//  ISSUtilityTests
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import Foundation
@testable import ISSUtility

extension APIClientSpy: API {}

class APIClientSpy {
	typealias ApiMessage = (request: URLRequest, completion: APIRequestCompletion)
	var capturedMessages = [ApiMessage]()
	func execute(_ request: URLRequest, completion: @escaping APIRequestCompletion) {
		capturedMessages.append((request, completion))
	}
}
