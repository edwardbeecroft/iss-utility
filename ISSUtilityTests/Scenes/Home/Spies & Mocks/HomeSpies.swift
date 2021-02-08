//
//  HomeSpies.swift
//  ISSUtilityTests
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import XCTest
@testable import ISSUtility

class HomeViewSpy: HomeViewProtocol {
	private(set) var capturedDisplayedViewModels: [HomeViewModel] = []
	func display(viewModel: HomeViewModel) {
		capturedDisplayedViewModels.append(viewModel)
	}
}

class HomePresenterSpy: HomePresenterProtocol {
	private(set) var onViewDidLoadCallCount: Int = 0
	func onViewDidLoad() {
		onViewDidLoadCallCount += 1
	}
	
	private(set) var onTappedFlyoversCallCount: Int = 0
	func onTappedFlyovers() {
		onTappedFlyoversCallCount += 1
	}
	
	private(set) var onTappedISSLocationCallCount: Int = 0
	func onTappedISSLocation() {
		onTappedISSLocationCallCount += 1
	}
	
	private(set) var onTappedCompassDirectionCallCount: Int = 0
	func onTappedCompassDirection() {
		onTappedCompassDirectionCallCount += 1
	}
}

class HomeRouterSpy: HomeRouterProtocol {
	private(set) var displayFlyoversCallCount: Int = 0
	func displayFlyovers() {
		displayFlyoversCallCount += 1
	}
	
	private(set) var displayISSLocationCallCount: Int = 0
	func displayISSLocation() {
		displayISSLocationCallCount += 1
	}
	
	private(set) var displayCompassDirectionCallCount: Int = 0
	func displayCompassDirection() {
		displayCompassDirectionCallCount += 1
	}
}

