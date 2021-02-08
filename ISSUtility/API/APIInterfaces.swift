//
//  APIInterfaces.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import Foundation

protocol NetworkSession {
	func execute(request: URLRequest,
				 completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

typealias APIRequestCompletion = ((Any?, NSError?) -> Void)

protocol API {
	func execute(_ request: URLRequest, completion: @escaping APIRequestCompletion)
}

enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case patch = "PATCH"
	case put = "PUT"
	case delete = "DELETE"
}
