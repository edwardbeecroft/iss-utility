//
//  ISSLocationRouter.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import UIKit

class ISSLocationRouter: RouterProtocol {
	
	// MARK: - Properties
	
	private(set) var navigation: UINavigationController
	private let parentRouter: ISSLocationParentRouterProtocol
	var childRouters: [RouterProtocol] = []
	
	// MARK: - Lifecycle
	
	init(navigation: UINavigationController,
		 parentRouter: ISSLocationParentRouterProtocol) {
		self.navigation = navigation
		self.parentRouter = parentRouter
	}
	
	func start() {
		let view = ISSLocationViewController()
		let interactor = ISSLocationInteractor(api: APIClient.shared,
											   requestBuilder: ISSLocationRequestBuilder(),
											   parser: ResponseParser())
		
		let presenter = ISSLocationPresenter(view: view,
											 interactor: interactor,
											 router: self)
		view.presenter = presenter
		navigation.pushViewController(view, animated: true)
	}
}

// MARK: - ISSLocationRouterProtocol

extension ISSLocationRouter: ISSLocationRouterProtocol {
	func popISSLocationView() {
		parentRouter.issLocationFlowComplete(self)
	}
}
