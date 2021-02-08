//
//  APIClient.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import Foundation

final class APIClient: API {
	
	// MARK: - Properties
	
	static var shared = APIClient()
	private let session: NetworkSession
	
	// MARK: - Lifecycle
	
	init(session: NetworkSession = URLSession.shared) {
		self.session = session
	}
	
	// MARK: - FlyoversAPI
	
	func execute(_ request: URLRequest, completion: @escaping APIRequestCompletion) {
		session.execute(request: request) { [weak self] data, response, error in
			guard let self = self else { return }
			self.process(data: data, response: (response as? HTTPURLResponse), error: error) { response, error in
				completion(response, error)
			}
		}
	}
}

// MARK: - Response Processing

private extension APIClient {
	func process(data: Data?, response: HTTPURLResponse?, error: Error?, completion: APIRequestCompletion) {
		if let nsError = error as NSError? {
			let responseError = NSError(domain: nsError.domain,
										code: nsError.code,
										userInfo: [NSLocalizedDescriptionKey: nsError.localizedDescription])
			completion(nil, responseError)
		} else if let data = data {
			do {
				let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
				completion(json, nil)
			} catch let error as NSError {
				let stringResponse = String(data: data, encoding: .utf8) ?? "<Cannot convert data to string>"
				let jsonError = NSError(domain: error.domain, code: error.code, userInfo: [NSLocalizedDescriptionKey: stringResponse])
				completion(nil, jsonError)
			}
		} else {
			completion(nil, nil)
		}
	}
}
