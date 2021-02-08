//
//  FlyoversInterfaces.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import CoreLocation

protocol FlyoversViewProtocol: AnyObject {
	func display(viewModel: FlyoversViewModel)
	func displayLoadingIndicator(display: Bool)
	func displayLocationPermissionsRequiredAlert()
	func displayLocationFetchFailedAlert()
	func displayFlyoverFetchFailedAlert()
	func displayNoConnectivityAlert()
}

protocol FlyoversPresenterProtocol: AnyObject {
	func onViewDidLoad()
	func onTappedRetryGetLocation()
	func onTappedRetryNotNow()
	func onTappedBack()
}

protocol FlyoversParentRouterProtocol: AnyObject {
	func flyoversFlowComplete(_ router: RouterProtocol)
}

protocol FlyoversRouterProtocol: AnyObject {
	func popFlyoversView()
}

protocol FlyoversInteractorProtocol: AnyObject {
	func fetchFlyoversForCoordinates(coordinates: CLLocationCoordinate2D,
									 completion: @escaping (FlyoversFetchResult) -> Void)
}

protocol FlyoversRequestBuilderProtocol {
	func prepareFlyoversRequestForCoordinates(_ coordinates: CLLocationCoordinate2D) -> URLRequest?
}

struct FlyoversViewModel {
	let flyovers: [Flyover]
	var titleString: String?
}

struct Flyover: Decodable {
	let duration: TimeInterval
	let risetime: TimeInterval
	
	private var fullDate: Date {
		return Date(timeIntervalSince1970: risetime)
	}
	var dateString: String {
		return DateFormatters.longDateFormatter.string(from: fullDate)
	}
	var timeString: String {
		return DateFormatters.timeFormatter.string(from: fullDate)
	}
}
