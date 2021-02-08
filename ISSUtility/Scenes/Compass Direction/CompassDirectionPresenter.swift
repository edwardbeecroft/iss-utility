//
//  CompassDirectionPresenter.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import CoreLocation
import UIKit

class CompassDirectionPresenter: NSObject {
	
	// MARK: - Properties
	
	private weak var view: CompassDirectionViewProtocol?
	private let interactor: ISSLocationInteractorProtocol
	private let router: CompassDirectionRouterProtocol
	private let locationProvider: LocationProviderProtocol

	// MARK: - Lifecycle
	
	init(view: CompassDirectionViewProtocol,
		 interactor: ISSLocationInteractorProtocol,
		 router: CompassDirectionRouterProtocol,
		 locationProvider: LocationProviderProtocol) {
		
		self.view = view
		self.interactor = interactor
		self.router = router
		self.locationProvider = locationProvider
	}
}

// MARK: - CompassDirectionPresenterProtocol

extension CompassDirectionPresenter: CompassDirectionPresenterProtocol {
	func onViewDidLoad() {
		attemptLocationUpdate()
	}
	
	func onTappedBack() {
		router.popCompassDirectionView()
	}
	
	func onTappedRetryGetLocation() {
		attemptLocationUpdate()
	}
	
	func onTappedRetryNotNow() {
		router.popCompassDirectionView()
	}
}

// MARK: - Networking (Location)

extension CompassDirectionPresenter {
	@objc private func attemptLocationUpdate() {
		guard let reachability = try? Reachability() else { return }

		guard reachability.connection != .unavailable else {
			view?.displayNoConnectivityAlert()
			return
		}
	
		view?.displayLoadingIndicator(display: true)
		
		locationProvider.getCurrentLocation { [weak self] outcome in
			guard let self = self else { return }
			switch outcome {
			case .success(let location):
				self.fetchISSLocation(userLocation: location)
			case .unauthorized:
				self.view?.displayLoadingIndicator(display: false)
				self.view?.displayLocationPermissionsRequiredAlert()
			case .error:
				self.showUseLocationFailedPopup()
			}
		}
	}
	
	private func showUseLocationFailedPopup() {
		view?.displayLoadingIndicator(display: false)
		view?.displayLocationFetchFailedAlert()
	}
}

// MARK: - Networking (ISS Location)

private extension CompassDirectionPresenter {
	func fetchISSLocation(userLocation: CLLocation) {
		interactor.fetchISSLocation { [weak self] result in
			guard let self = self else { return }
			
			DispatchQueue.main.async {
				self.view?.displayLoadingIndicator(display: false)

				switch result {
				case .success(let successResponse):
					guard let issCoordinates = successResponse.coordinates.coordinate2D else {
						self.view?.displayISSLocationFetchFailedAlert()
						return
					}
					self.calculateBearing(userLocation: userLocation,
										  issCoordinates: issCoordinates)
				case .failure:
					self.view?.displayISSLocationFetchFailedAlert()
				}
			}
		}
	}
}

// MARK: - Calculation of Orientation

private extension CompassDirectionPresenter {
	func calculateBearing(userLocation: CLLocation,
						  issCoordinates: CLLocationCoordinate2D) {
		
		let userCoordinates = userLocation.coordinate
		let bearing = userCoordinates.bearing(to: issCoordinates)
		
		logUserLocationInfoIfSimulator(course: userLocation.course,
									   userCoordinates: userCoordinates,
									   bearing: bearing)
		
		logISSCoordinatesIfSimulator(issCoordinates: issCoordinates)
		
		let userLocationString = "User: \(userCoordinates.latitude), \(userCoordinates.longitude)"
		let issLocationString = "ISS: \(issCoordinates.latitude), \(issCoordinates.longitude)"
		
		let angleInRadians = CGFloat(bearing).degreesToRadians
		
		let viewModel = CompassDirectionViewModel(userLocation: userLocationString,
												  issLocation: issLocationString,
												  angleInRadians: angleInRadians)
		view?.display(viewModel: viewModel)
	}
}

// MARK: - Debug Logging

private extension CompassDirectionPresenter {
	func logUserLocationInfoIfSimulator(course: CLLocationDirection,
										userCoordinates: CLLocationCoordinate2D,
										bearing: Double) {
		#if targetEnvironment(simulator)
		print("***** DEBUG LOCATION: USER *****")
		print("User Course: \(course)")
		print("User Coordinates: \(userCoordinates)")
		print("User Bearing to ISS: \(bearing) degrees")
		#endif
	}
	func logISSCoordinatesIfSimulator(issCoordinates: CLLocationCoordinate2D) {
		#if targetEnvironment(simulator)
		print("***** DEBUG LOCATION: ISS *****")
		print("ISS Coordinates: \(issCoordinates)")
		#endif
	}
}
