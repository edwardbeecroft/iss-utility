//
//  MockResponseParser.swift
//  ISSUtilityTests
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import Foundation
@testable import ISSUtility

class MockResponseParser: Parser {
	var shouldSucceed = true
	func parse<T>(responseObject: Any?, jsonDecoder: JSONDecoder) -> ParseResult<T> where T: Decodable {
		if shouldSucceed {
			return ResponseParser().parse(responseObject: responseObject, jsonDecoder: jsonDecoder)
		} else {
			return .failure
		}
	}
}
