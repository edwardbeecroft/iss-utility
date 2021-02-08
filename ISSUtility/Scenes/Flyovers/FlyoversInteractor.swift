//
//  FlyoversInteractor.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import CoreLocation

enum FlyoversFetchResult {
	case success(FlyoversFetchResponse)
	case failure(FlyoversFetchError)
}

enum FlyoversFetchError: Error {
	case general
	case internalServer
	case invalidRequest
	case parsing
	
	init(errorCode: Int) {
		switch errorCode {
		case 500...599:
			self = .internalServer
		default:
			self = .general
		}
	}
}

struct FlyoversFetchResponse: Decodable {
	let message: String
	let flyovers: [Flyover]

	private enum CodingKeys: String, CodingKey {
		case message = "message"
		case flyovers = "response"
	}
}

class FlyoversInteractor {
	
	// MARK: - Properties
	
	private let api: API
	private let requestBuilder: FlyoversRequestBuilderProtocol
	private let parser: Parser
	
	// MARK: - Lifecycle
	
	init(api: API,
		 requestBuilder: FlyoversRequestBuilderProtocol,
		 parser: Parser) {
		self.api = api
		self.requestBuilder = requestBuilder
		self.parser = parser
	}
}

// MARK: - FlyoversInteractorProtocol

extension FlyoversInteractor: FlyoversInteractorProtocol {
	func fetchFlyoversForCoordinates(coordinates: CLLocationCoordinate2D,
									 completion: @escaping (FlyoversFetchResult) -> Void) {
		guard let request = requestBuilder.prepareFlyoversRequestForCoordinates(coordinates) else {
			return completion(.failure(.invalidRequest))
		}

		api.execute(request) { [weak self] response, error in

			guard let self = self else { return completion(.failure(.general)) }

			if let error = error {
				return completion(.failure(FlyoversFetchError(errorCode: error.code)))
			}

			let parsingResult: ParseResult<FlyoversFetchResponse> = self.parser.parse(responseObject: response)
			
			switch parsingResult {
			case .success(let successResponse):
				self.logFlyoversIfSimulator(successResponse.flyovers)
				completion(.success(successResponse))
			case .failure:
				completion(.failure(.parsing))
			}
		}
	}
}

// MARK: - Debug Logging

private extension FlyoversInteractor {
	func logFlyoversIfSimulator(_ flyovers: [Flyover]) {
		#if targetEnvironment(simulator)
		print("***** DEBUG: FLYOVER TIMES *****")
		flyovers.forEach({
			print("Flyover: \($0.dateString) - \($0.timeString)")
		})
		#endif
	}
}
