//
//  APIResponseParser.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import Foundation

protocol Parser {
	func parse<T: Decodable>(responseObject: Any?, jsonDecoder: JSONDecoder) -> ParseResult<T>
}

enum ParseResult<T> {
	case success(T)
	case failure
}

extension Parser {
	func parse<T: Decodable>(responseObject: Any?, jsonDecoder: JSONDecoder = JSONDecoder()) -> ParseResult<T> {
		return parse(responseObject: responseObject, jsonDecoder: jsonDecoder)
	}
}

class ResponseParser: Parser {
	func parse<T: Decodable>(responseObject: Any?,
							 jsonDecoder: JSONDecoder) -> ParseResult<T> {
		
		guard let data = dictToData(responseObject: responseObject) else {
			return .failure
		}
		
		if let responseObject: T = parseResponse(data: data, with: jsonDecoder) {
			return .success(responseObject)
		} else {
			return .failure
		}
	}
	
	private func parseResponse<T: Decodable>(data: Data, with jsonDecoder: JSONDecoder) -> T? {
		return try? jsonDecoder.decode(T.self, from: data)
	}
	
	private func dictToData(responseObject: Any?) -> Data? {
		guard
			let response = responseObject,
			let dict = response as? [String: Any],
			let data = dict.jsonData
			else {
				return nil
		}
		
		return data
	}
}
