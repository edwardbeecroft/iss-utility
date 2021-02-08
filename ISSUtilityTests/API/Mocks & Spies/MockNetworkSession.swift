//
//  MockNetworkSession.swift
//  ISSUtilityTests
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import Foundation
@testable import ISSUtility

class MockNetworkSession: NetworkSession {
	var completionArgs: (Data?, URLResponse?, Error?) = (nil, nil, nil)
	func execute(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
		completion(completionArgs.0, completionArgs.1, completionArgs.2)
	}
}
