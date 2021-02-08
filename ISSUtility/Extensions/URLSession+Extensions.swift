//
//  URLSession+Extensions.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import Foundation

extension URLSession: NetworkSession {
	func execute(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
		let task = dataTask(with: request) { (data, response, error) in
			completion(data, response, error)
		}
		task.resume()
	}
}
