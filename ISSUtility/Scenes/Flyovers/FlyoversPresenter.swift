//
//  FlyoversPresenter.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import CoreLocation
import Contacts

class FlyoversPresenter: NSObject {
	
	// MARK: - Properties
	
	private weak var view: FlyoversViewProtocol?
	private let interactor: FlyoversInteractorProtocol
	private let router: FlyoversRouterProtocol
	private let locationProvider: LocationProviderProtocol

	// MARK: - Lifecycle
	
	init(view: FlyoversViewProtocol,
		 interactor: FlyoversInteractorProtocol,
		 router: FlyoversRouterProtocol,
		 locationProvider: LocationProviderProtocol) {
		
		self.view = view
		self.interactor = interactor
		self.router = router
		self.locationProvider = locationProvider
	}
}

// MARK: - FlyoversPresenterProtocol

extension FlyoversPresenter: FlyoversPresenterProtocol {
	func onViewDidLoad() {
		attemptLocationUpdate()
	}
	
	func onTappedBack() {
		router.popFlyoversView()
	}
	
	func onTappedRetryGetLocation() {
		attemptLocationUpdate()
	}
	
	func onTappedRetryNotNow() {
		router.popFlyoversView()
	}
}

// MARK: - Networking (Location)

extension FlyoversPresenter {
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
				self.handleReceivedLocation(location)
			case .unauthorized:
				self.view?.displayLoadingIndicator(display: false)
				self.view?.displayLocationPermissionsRequiredAlert()
			case .error:
				self.showUseLocationFailedPopup()
			}
		}
	}
	
	private func handleReceivedLocation(_ location: CLLocation) {
		location.geocode { [weak self] placemarks, error in
			guard let self = self else { return }
			guard error == nil else {
				return self.showUseLocationFailedPopup()
			}
			
			let locationString = placemarks?.first?.makeAddressString()
			self.fetchFlyoversForCoordinates(location.coordinate,
											 locationString: locationString)
		}
	}
	
	private func showUseLocationFailedPopup() {
		view?.displayLoadingIndicator(display: false)
		view?.displayLocationFetchFailedAlert()
	}
}

// MARK: - Networking (Flyover Times)

extension FlyoversPresenter {
	func fetchFlyoversForCoordinates(_ coordinates: CLLocationCoordinate2D,
									 locationString: String?) {
		interactor.fetchFlyoversForCoordinates(coordinates: coordinates) { [weak self] result in
			guard let self = self else { return }
			DispatchQueue.main.async {
				self.view?.displayLoadingIndicator(display: false)

				switch result {
				case .success(let successResponse):
					self.view?.display(viewModel: FlyoversViewModel(flyovers: successResponse.flyovers,
																	titleString: locationString))
				case .failure:
					self.view?.displayFlyoverFetchFailedAlert()
				}
			}
		}
	}
}
