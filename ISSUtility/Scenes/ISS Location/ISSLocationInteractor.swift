//
//  ISSLocationInteractor.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import CoreLocation

enum ISSLocationFetchResult {
	case success(ISSLocationFetchResponse)
	case failure(ISSLocationFetchError)
}

enum ISSLocationFetchError: Error {
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

struct ISSLocationFetchResponse: Decodable {
	let message: String
	let coordinates: ISSCoordinates

	private enum CodingKeys: String, CodingKey {
		case message = "message"
		case coordinates = "iss_position"
	}
}

class ISSLocationInteractor {
	
	// MARK: - Properties
	
	private let api: API
	private let requestBuilder: ISSLocationRequestBuilderProtocol
	private let parser: Parser
	
	// MARK: - Lifecycle
	
	init(api: API,
		 requestBuilder: ISSLocationRequestBuilderProtocol,
		 parser: Parser) {
		self.api = api
		self.requestBuilder = requestBuilder
		self.parser = parser
	}
}

// MARK: - ISSLocationInteractorProtocol

extension ISSLocationInteractor: ISSLocationInteractorProtocol {
	func fetchISSLocation(completion: @escaping (ISSLocationFetchResult) -> Void) {
		guard let request = requestBuilder.prepareISSLocationRequest() else {
			return completion(.failure(.invalidRequest))
		}
		api.execute(request) { [weak self] response, error in
			guard let self = self else { return completion(.failure(.general)) }
			
			if let error = error {
				return completion(.failure(ISSLocationFetchError(errorCode: error.code)))
			}
			
			let parsingResult: ParseResult<ISSLocationFetchResponse> = self.parser.parse(responseObject: response)
			
			switch parsingResult {
			case .success(let successResponse):
				completion(.success(successResponse))
			case .failure:
				completion(.failure(.parsing))
			}
		}
	}
}
