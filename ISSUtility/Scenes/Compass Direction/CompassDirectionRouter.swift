//
//  CompassDirectionRouter.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import UIKit
import CoreLocation

class CompassDirectionRouter: RouterProtocol {
	
	// MARK: - Properties
	
	private(set) var navigation: UINavigationController
	private let parentRouter: CompassDirectionParentRouterProtocol
	var childRouters: [RouterProtocol] = []
	
	// MARK: - Lifecycle
	
	init(navigation: UINavigationController,
		 parentRouter: CompassDirectionParentRouterProtocol) {
		self.navigation = navigation
		self.parentRouter = parentRouter
	}
	
	func start() {
		let view = CompassDirectionViewController()
		let interactor = ISSLocationInteractor(api: APIClient.shared,
											   requestBuilder: ISSLocationRequestBuilder(),
											   parser: ResponseParser())
		let locationProvider = LocationProvider(locationManager: CLLocationManager())
		let presenter = CompassDirectionPresenter(view: view,
												  interactor: interactor,
												  router: self,
												  locationProvider: locationProvider)
		view.presenter = presenter
		navigation.pushViewController(view, animated: true)
	}
}

// MARK: - CompassDirectionRouterProtocol

extension CompassDirectionRouter: CompassDirectionRouterProtocol {
	func popCompassDirectionView() {
		parentRouter.compassDirectionFlowComplete(self)
	}
}
