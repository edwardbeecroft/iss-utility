//
//  ISSLocationInterfaces.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import Foundation
import CoreLocation

protocol ISSLocationViewProtocol: AnyObject {
	func display(viewModel: ISSLocationViewModel)
	func displayLoadingIndicator(display: Bool)
	func displayISSLocationFetchFailedAlert()
	func displayNoConnectivityAlert()
}

protocol ISSLocationPresenterProtocol: AnyObject {
	func onViewDidLoad()
	func onTappedRetry()
	func onTappedRetryNotNow()
	func onTappedBack()
}

protocol ISSLocationParentRouterProtocol: AnyObject {
	func issLocationFlowComplete(_ router: RouterProtocol)
}

protocol ISSLocationRouterProtocol: AnyObject {
	func popISSLocationView()
}

protocol ISSLocationInteractorProtocol: AnyObject {
	func fetchISSLocation(completion: @escaping (ISSLocationFetchResult) -> Void)
}

protocol ISSLocationRequestBuilderProtocol {
	func prepareISSLocationRequest() -> URLRequest?
}

struct ISSLocationViewModel {
	let coordinates: CLLocationCoordinate2D
}

struct ISSCoordinates: Decodable {

	var coordinate2D: CLLocationCoordinate2D? {
		guard
			let longitude = Double(longitudeString),
			let latitude = Double(latitudeString) else {
				return nil
		}
		return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}
	
	private let longitudeString: String
	private let latitudeString: String
	
	private enum CodingKeys: String, CodingKey {
		case longitudeString = "longitude"
		case latitudeString = "latitude"
	}
}
