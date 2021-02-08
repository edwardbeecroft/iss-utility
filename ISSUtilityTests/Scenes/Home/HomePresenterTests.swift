//
//  HomePresenterTests.swift
//  ISSUtilityTests
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import XCTest
@testable import ISSUtility

class HomePresenterTests: XCTestCase {
	
	// MARK: - View Tests
	
	func testOnViewDidLoadCallsDisplayViewModelOnView() {
		let view = HomeViewSpy()
		let sut = makeSUT(view: view)
		
		XCTAssertEqual(view.capturedDisplayedViewModels.count, 0)
		
		sut.onViewDidLoad()
		
		XCTAssertEqual(view.capturedDisplayedViewModels.count, 1)
	}
	
	// MARK: - Router Tests
	
	func testOnTappedFlyoversCallsDisplayFlyoversOnRouter() {
		let router = HomeRouterSpy()
		let sut = makeSUT(router: router)
		
		XCTAssertEqual(router.displayFlyoversCallCount, 0)
		
		sut.onTappedFlyovers()
		
		XCTAssertEqual(router.displayFlyoversCallCount, 1)
	}
	
	func testOnTappedISSLocationCallsDisplayISSLocationOnRouter() {
		let router = HomeRouterSpy()
		let sut = makeSUT(router: router)
		
		XCTAssertEqual(router.displayISSLocationCallCount, 0)
		
		sut.onTappedISSLocation()
		
		XCTAssertEqual(router.displayISSLocationCallCount, 1)
	}
	
	func testOnTappedCompassDirectionCallsDisplayCompassDirectionOnRouter() {
		let router = HomeRouterSpy()
		let sut = makeSUT(router: router)
		
		XCTAssertEqual(router.displayCompassDirectionCallCount, 0)
		
		sut.onTappedCompassDirection()
		
		XCTAssertEqual(router.displayCompassDirectionCallCount, 1)
	}
	
	// MARK: - Helpers
	
	private func makeSUT(view: HomeViewProtocol = HomeViewSpy(),
						 router: HomeRouterProtocol = HomeRouterSpy()) -> HomePresenter {
		let presenter = HomePresenter(view: view,
									  router: router)
		return presenter
	}
}
