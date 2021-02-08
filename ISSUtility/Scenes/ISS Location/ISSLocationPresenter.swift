//
//  ISSLocationPresenter.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import Foundation

class ISSLocationPresenter {
	
	// MARK: - Properties
	
	private weak var view: ISSLocationViewProtocol?
	private let interactor: ISSLocationInteractorProtocol
	private let router: ISSLocationRouterProtocol

	// MARK: - Lifecycle
	
	init(view: ISSLocationViewProtocol,
		 interactor: ISSLocationInteractorProtocol,
		 router: ISSLocationRouterProtocol) {
		
		self.view = view
		self.interactor = interactor
		self.router = router
	}
}

// MARK: - ISSLocationPresenterProtocol

extension ISSLocationPresenter: ISSLocationPresenterProtocol {
	func onViewDidLoad() {
		fetchISSLocation()
	}
	
	func onTappedBack() {
		router.popISSLocationView()
	}
	
	func onTappedRetry() {
		fetchISSLocation()
	}
	
	func onTappedRetryNotNow() {
		router.popISSLocationView()
	}
}

// MARK: - Networking (ISS Location)

private extension ISSLocationPresenter {
	func fetchISSLocation() {
		guard let reachability = try? Reachability() else { return }
		
		guard reachability.connection != .unavailable else {
			view?.displayNoConnectivityAlert()
			return
		}
		
		self.view?.displayLoadingIndicator(display: true)
		
		interactor.fetchISSLocation { [weak self] result in
			guard let self = self else { return }
			
			DispatchQueue.main.async {
				self.view?.displayLoadingIndicator(display: false)
				
				switch result {
				case .success(let successResponse):
					guard let coordinates = successResponse.coordinates.coordinate2D else {
						self.view?.displayISSLocationFetchFailedAlert()
						return
					}
					self.view?.display(viewModel: ISSLocationViewModel(coordinates: coordinates))
				case .failure:
					self.view?.displayISSLocationFetchFailedAlert()
				}
			}
		}
	}
}
