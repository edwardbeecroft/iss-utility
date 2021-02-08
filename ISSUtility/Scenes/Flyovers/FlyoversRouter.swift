//
//  FlyoversRouter.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import UIKit
import CoreLocation

class FlyoversRouter: RouterProtocol {
	
	// MARK: - Properties
	
	private(set) var navigation: UINavigationController
	private let parentRouter: FlyoversParentRouterProtocol
	var childRouters: [RouterProtocol] = []
	
	// MARK: - Lifecycle
	
	init(navigation: UINavigationController,
		 parentRouter: FlyoversParentRouterProtocol) {
		self.navigation = navigation
		self.parentRouter = parentRouter
	}
	
	func start() {
		let view = FlyoversViewController()
		let interactor = FlyoversInteractor(api: APIClient.shared,
											requestBuilder: FlyoversRequestBuilder(),
											parser: ResponseParser())
		let locationProvider = LocationProvider(locationManager: CLLocationManager())
		let presenter = FlyoversPresenter(view: view,
										  interactor: interactor,
										  router: self,
										  locationProvider: locationProvider)
		view.presenter = presenter
		navigation.pushViewController(view, animated: true)
	}
}

// MARK: - FlyoversRouterProtocol

extension FlyoversRouter: FlyoversRouterProtocol {
	func popFlyoversView() {
		parentRouter.flyoversFlowComplete(self)
	}
}
