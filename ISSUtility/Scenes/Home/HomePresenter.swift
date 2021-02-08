//
//  HomePresenter.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

class HomePresenter {
	
	// MARK: - Properties
	
	private weak var view: HomeViewProtocol?
	private let router: HomeRouterProtocol
	
	// MARK: - Lifecycle
	
	init(view: HomeViewProtocol,
		 router: HomeRouterProtocol) {
		
		self.view = view
		self.router = router
	}
}

// MARK: - HomePresenterProtocol

extension HomePresenter: HomePresenterProtocol {
	func onViewDidLoad() {
		view?.display(viewModel: generateViewModel())
	}
	
	func onTappedFlyovers() {
		router.displayFlyovers()
	}
	
	func onTappedISSLocation() {
		router.displayISSLocation()
	}
	
	func onTappedCompassDirection() {
		router.displayCompassDirection()
	}
}

// MARK: - Helpers

private extension HomePresenter {
	func generateViewModel() -> HomeViewModel {
		return HomeViewModel(options: HomeOption.allCases)
	}
}
