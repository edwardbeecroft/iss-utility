//
//  HomeRouter.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import UIKit

class HomeRouter {
	
	// MARK: - Properties
	
	private(set) var navigation: UINavigationController
	var childRouters: [RouterProtocol] = []
	
	// MARK: - Lifecycle
	
	init(navigation: UINavigationController) {
		self.navigation = navigation
	}
}

// MARK: - Module Construction

extension HomeRouter {
	func buildLaunchModule() {
		let homeViewController = HomeViewController()
		navigation.setViewControllers([homeViewController], animated: false)
		navigation.setNavigationBarHidden(true, animated: false)
		let homePresenter = HomePresenter(view: homeViewController,
										  router: self)
		homeViewController.presenter = homePresenter
	}
}

// MARK: - HomeRouterProtocol

extension HomeRouter: HomeRouterProtocol {
	func displayFlyovers() {
		let router = FlyoversRouter(navigation: navigation,
									parentRouter: self)
		childRouters.append(router)
		router.start()
	}
	
	func displayISSLocation() {
		let router = ISSLocationRouter(navigation: navigation,
									   parentRouter: self)
		childRouters.append(router)
		router.start()
	}
	
	func displayCompassDirection() {
		let router = CompassDirectionRouter(navigation: navigation,
											parentRouter: self)
		childRouters.append(router)
		router.start()
	}
}

// MARK: - FlyoversParentRouterProtocol

extension HomeRouter: FlyoversParentRouterProtocol {
	func flyoversFlowComplete(_ router: RouterProtocol) {
		childRouters = childRouters.filter {$0 !== router}
		navigation.popViewController(animated: true)
	}
}

// MARK: - ISSLocationParentRouterProtocol

extension HomeRouter: ISSLocationParentRouterProtocol {
	func issLocationFlowComplete(_ router: RouterProtocol) {
		childRouters = childRouters.filter {$0 !== router}
		navigation.popViewController(animated: true)
	}
}

// MARK: - CompassDirectionParentRouterProtocol

extension HomeRouter: CompassDirectionParentRouterProtocol {
	func compassDirectionFlowComplete(_ router: RouterProtocol) {
		childRouters = childRouters.filter {$0 !== router}
		navigation.popViewController(animated: true)
	}
}
