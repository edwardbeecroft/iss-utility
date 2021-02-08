//
//  HomeViewControllerTests.swift
//  ISSUtilityTests
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import XCTest
@testable import ISSUtility

class HomeViewControllerTests: XCTestCase {

	// MARK: - Presenter Tests
	
	func testViewDidLoadCallsViewDidLoadOnPresenter() {
		let presenter = HomePresenterSpy()
		let sut = makeSUT(presenter: presenter)
		let originalViewDidLoadCallCount = presenter.onViewDidLoadCallCount
		
		XCTAssertEqual(presenter.onViewDidLoadCallCount, originalViewDidLoadCallCount)
		
		sut.viewDidLoad()
		
		XCTAssertEqual(presenter.onViewDidLoadCallCount, originalViewDidLoadCallCount + 1)
	}
	
	func testDisplayViewModelConfiguresViewCorrectly() {
		let sut = makeSUT()
		
		XCTAssertEqual(sut.stackView.arrangedSubviews.count, 0)
		
		let viewModel = HomeViewModel(options: HomeOption.allCases)
		sut.display(viewModel: viewModel)
		
		XCTAssertEqual(sut.stackView.arrangedSubviews.count, viewModel.options.count)
		
		guard let homeOptionViews = sut.stackView.arrangedSubviews as? [HomeOptionView] else {
			return XCTFail("Expected home option views")
		}
		HomeOption.allCases.forEach({ option in
			XCTAssertTrue(homeOptionViews.compactMap({ $0.optionLabel.text }).contains(option.title))
		})
	}
	
	func testFlyoverOptionTappedCallsOnTappedFlyoversOnPresenter() {
		let presenter = HomePresenterSpy()
		let sut = makeSUT(presenter: presenter)
		
		let viewModel = HomeViewModel(options: HomeOption.allCases)
		sut.display(viewModel: viewModel)
		
		XCTAssertEqual(sut.stackView.arrangedSubviews.count, viewModel.options.count)
		
		guard
			let homeOptionViews = sut.stackView.arrangedSubviews as? [HomeOptionView],
			let flyoversOption = homeOptionViews.first(where: { $0.option == .flyovers }) else {
			return XCTFail("Expected flyover option view")
		}
		
		XCTAssertEqual(presenter.onTappedFlyoversCallCount, 0)
		
		flyoversOption.optionTappedHandler()
		
		XCTAssertEqual(presenter.onTappedFlyoversCallCount, 1)
	}
	
	func testISSLocationOptionTappedCallsOnTappedISSLocationOnPresenter() {
		let presenter = HomePresenterSpy()
		let sut = makeSUT(presenter: presenter)
		
		let viewModel = HomeViewModel(options: HomeOption.allCases)
		sut.display(viewModel: viewModel)
		
		XCTAssertEqual(sut.stackView.arrangedSubviews.count, viewModel.options.count)
		
		guard
			let homeOptionViews = sut.stackView.arrangedSubviews as? [HomeOptionView],
			let issLocationOption = homeOptionViews.first(where: { $0.option == .issLocation }) else {
			return XCTFail("Expected iss location option view")
		}
		
		XCTAssertEqual(presenter.onTappedISSLocationCallCount, 0)
		
		issLocationOption.optionTappedHandler()
		
		XCTAssertEqual(presenter.onTappedISSLocationCallCount, 1)
	}
	
	func testCompassDirectionOptionTappedCallsOnTappedCompassDirectionOnPresenter() {
		let presenter = HomePresenterSpy()
		let sut = makeSUT(presenter: presenter)
		
		let viewModel = HomeViewModel(options: HomeOption.allCases)
		sut.display(viewModel: viewModel)
		
		XCTAssertEqual(sut.stackView.arrangedSubviews.count, viewModel.options.count)
		
		guard
			let homeOptionViews = sut.stackView.arrangedSubviews as? [HomeOptionView],
			let compassDirectionOption = homeOptionViews.first(where: { $0.option == .issCompassDirection }) else {
			return XCTFail("Expected compass direction option view")
		}
		
		XCTAssertEqual(presenter.onTappedCompassDirectionCallCount, 0)
		
		compassDirectionOption.optionTappedHandler()
		
		XCTAssertEqual(presenter.onTappedCompassDirectionCallCount, 1)
	}
	
	// MARK: - Helpers
	
	private func makeSUT(presenter: HomePresenterProtocol = HomePresenterSpy()) -> HomeViewController {
		let viewController = HomeViewController()
		viewController.presenter = presenter
		viewController.loadView()
		return viewController
	}
}
