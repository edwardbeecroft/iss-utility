//
//  HomeRouterTests.swift
//  ISSUtilityTests
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import XCTest
@testable import ISSUtility

class HomeRouterTests: XCTestCase {
	
	// MARK: - Build Tests
	
	func testBuildLaunchModuleCreatesValidModule() {
		let navigation = MockNavigationController()
		let router = makeSUT(navigation: navigation)
		
		XCTAssertEqual(navigation.children.count, 0)
		
		router.buildLaunchModule()
		
		XCTAssertTrue(navigation.children.contains(where: { $0 is HomeViewController }))
		XCTAssertEqual(navigation.children.count, 1)
	}
	
	// MARK: - HomeRouterProtocol Tests
	
	func testDisplayFlyoversCreatesFlyoversModule() {
		let navigation = MockNavigationController()
		let router = makeSUT(navigation: navigation)
		
		XCTAssertEqual(navigation.children.count, 0)
		XCTAssertEqual(router.childRouters.count, 0)
		
		router.displayFlyovers()
		
		XCTAssertEqual(navigation.children.count, 1)
		XCTAssertTrue(navigation.children.contains(where: { $0 is FlyoversViewController }))
		XCTAssertEqual(router.childRouters.count, 1)
		XCTAssertTrue(router.childRouters.contains(where: { $0 is FlyoversRouter }))
	}
	
	// MARK: - Helpers
	
	private func makeSUT(navigation: UINavigationController = MockNavigationController()) -> HomeRouter {
		let router = HomeRouter(navigation: navigation)
		return router
	}
}
