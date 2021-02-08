//
//  FlyoversViewControllerTests.swift
//  ISSUtilityTests
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import XCTest
@testable import ISSUtility

class FlyoversViewControllerTests: XCTestCase {

	// MARK: - Presenter Tests
	
	func testViewDidLoadCallsViewDidLoadOnPresenter() {
		let presenter = FlyoversPresenterSpy()
		let sut = makeSUT(presenter: presenter)
		let originalViewDidLoadCallCount = presenter.onViewDidLoadCallCount
		
		XCTAssertEqual(presenter.onViewDidLoadCallCount, originalViewDidLoadCallCount)
		
		sut.viewDidLoad()
		
		XCTAssertEqual(presenter.onViewDidLoadCallCount, originalViewDidLoadCallCount + 1)
	}
	
	func testBackButtonTappedCallsOnTappedBackOnPresenter() {
		let presenter = FlyoversPresenterSpy()
		let sut = makeSUT(presenter: presenter)
		
		guard
			let backButtonItem = sut.navigationItem.leftBarButtonItem,
			let backButtonAction = backButtonItem.action else {
			XCTFail("Back button is not configured correctly.")
			return
		}

		XCTAssertEqual(presenter.onTappedBackCallCount, 0)
		
		_ = backButtonItem.target?.perform(backButtonAction)
		
		XCTAssertEqual(presenter.onTappedBackCallCount, 1)
	}
	
	func testLocationPermissionsAlertNotNowTappedCallsOnTappedRetryNotNowOnPresenter() {
		let presenter = FlyoversPresenterSpy()
		let sut = makeSUT(presenter: presenter)
		sut.viewDidLoad()
		
		let alertControllerSpy = BaseViewAlertControllerSpy()
		sut.alertController = alertControllerSpy
		
		XCTAssertEqual(alertControllerSpy.alertMessages.count, 0)
		sut.displayLocationPermissionsRequiredAlert()
		XCTAssertEqual(alertControllerSpy.alertMessages.count, 1)
		
		XCTAssertEqual(presenter.onTappedRetryNotNowCallCount, 0)
		alertControllerSpy.alertMessages.first?.actions.first?.completion?()
		XCTAssertEqual(presenter.onTappedRetryNotNowCallCount, 1)
	}
	
	func testLocationFetchFailedAlertNotNowTappedCallsOnTappedRetryNotNowOnPresenter() {
		let presenter = FlyoversPresenterSpy()
		let sut = makeSUT(presenter: presenter)
		sut.viewDidLoad()
		
		let alertControllerSpy = BaseViewAlertControllerSpy()
		sut.alertController = alertControllerSpy
		
		XCTAssertEqual(alertControllerSpy.alertMessages.count, 0)
		sut.displayLocationFetchFailedAlert()
		XCTAssertEqual(alertControllerSpy.alertMessages.count, 1)
		
		XCTAssertEqual(presenter.onTappedRetryNotNowCallCount, 0)
		alertControllerSpy.alertMessages.first?.actions.first?.completion?()
		XCTAssertEqual(presenter.onTappedRetryNotNowCallCount, 1)
	}
	
	func testLocationFetchFailedAlertRetryTappedCallsOnTappedRetryGetLocationOnPresenter() {
		let presenter = FlyoversPresenterSpy()
		let sut = makeSUT(presenter: presenter)
		sut.viewDidLoad()
		
		let alertControllerSpy = BaseViewAlertControllerSpy()
		sut.alertController = alertControllerSpy
		
		XCTAssertEqual(alertControllerSpy.alertMessages.count, 0)
		sut.displayLocationFetchFailedAlert()
		XCTAssertEqual(alertControllerSpy.alertMessages.count, 1)
		
		XCTAssertEqual(presenter.onTappedRetryGetLocationCallCount, 0)
		alertControllerSpy.alertMessages.first?.actions.last?.completion?()
		XCTAssertEqual(presenter.onTappedRetryGetLocationCallCount, 1)
	}
	
	func testFlyoverFetchFailedAlertNotNowTappedCallsOnTappedRetryNotNowOnPresenter() {
		let presenter = FlyoversPresenterSpy()
		let sut = makeSUT(presenter: presenter)
		sut.viewDidLoad()
		
		let alertControllerSpy = BaseViewAlertControllerSpy()
		sut.alertController = alertControllerSpy
		
		XCTAssertEqual(alertControllerSpy.alertMessages.count, 0)
		sut.displayFlyoverFetchFailedAlert()
		XCTAssertEqual(alertControllerSpy.alertMessages.count, 1)
		
		XCTAssertEqual(presenter.onTappedRetryNotNowCallCount, 0)
		alertControllerSpy.alertMessages.first?.actions.first?.completion?()
		XCTAssertEqual(presenter.onTappedRetryNotNowCallCount, 1)
	}
	
	func testFlyoverFetchFailedAlertRetryTappedCallsOnTappedRetryGetLocationOnPresenter() {
		let presenter = FlyoversPresenterSpy()
		let sut = makeSUT(presenter: presenter)
		sut.viewDidLoad()
		
		let alertControllerSpy = BaseViewAlertControllerSpy()
		sut.alertController = alertControllerSpy
		
		XCTAssertEqual(alertControllerSpy.alertMessages.count, 0)
		sut.displayFlyoverFetchFailedAlert()
		XCTAssertEqual(alertControllerSpy.alertMessages.count, 1)
		
		XCTAssertEqual(presenter.onTappedRetryGetLocationCallCount, 0)
		alertControllerSpy.alertMessages.first?.actions.last?.completion?()
		XCTAssertEqual(presenter.onTappedRetryGetLocationCallCount, 1)
	}
	
	func testNoConnectivityAlertNotNowTappedCallsOnTappedRetryNotNowOnPresenter() {
		let presenter = FlyoversPresenterSpy()
		let sut = makeSUT(presenter: presenter)
		sut.viewDidLoad()
		
		let alertControllerSpy = BaseViewAlertControllerSpy()
		sut.alertController = alertControllerSpy
		
		XCTAssertEqual(alertControllerSpy.alertMessages.count, 0)
		sut.displayNoConnectivityAlert()
		XCTAssertEqual(alertControllerSpy.alertMessages.count, 1)
		
		XCTAssertEqual(presenter.onTappedRetryNotNowCallCount, 0)
		alertControllerSpy.alertMessages.first?.actions.first?.completion?()
		XCTAssertEqual(presenter.onTappedRetryNotNowCallCount, 1)
	}
	
	func testNoConnectivityAlertRetryTappedCallsOnTappedRetryGetLocationOnPresenter() {
		let presenter = FlyoversPresenterSpy()
		let sut = makeSUT(presenter: presenter)
		sut.viewDidLoad()
		
		let alertControllerSpy = BaseViewAlertControllerSpy()
		sut.alertController = alertControllerSpy
		
		XCTAssertEqual(alertControllerSpy.alertMessages.count, 0)
		sut.displayNoConnectivityAlert()
		XCTAssertEqual(alertControllerSpy.alertMessages.count, 1)
		
		XCTAssertEqual(presenter.onTappedRetryGetLocationCallCount, 0)
		alertControllerSpy.alertMessages.first?.actions.last?.completion?()
		XCTAssertEqual(presenter.onTappedRetryGetLocationCallCount, 1)
	}
	
	// MARK: - View Tests
	
	func testDisplayViewModelRendersCellsCorrectly() {
		let sut = makeSUT()
	
		XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)

		let viewModel = FlyoversViewModel(flyovers: [Flyover(duration: 50, risetime: 1000)],
										  titleString: "25 Monument Street, London, ECR3 8BQ")
		sut.display(viewModel: viewModel)
		
		XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
		XCTAssertNotNil(sut.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FlyoversTableViewCell)
	}
	
	func testDisplayLoadingIndicatorUpdatesUICorrectly() {
		let sut = makeSUT()
		
		XCTAssertFalse(sut.view.subviews.contains(where: { $0 is UIActivityIndicatorView }))
		XCTAssertFalse(sut.activityIndicator.isAnimating)
		XCTAssertFalse(sut.tableView.isHidden)
		
		sut.displayLoadingIndicator(display: true)
		
		XCTAssertTrue(sut.view.subviews.contains(where: { $0 is UIActivityIndicatorView }))
		XCTAssertTrue(sut.activityIndicator.isAnimating)
		XCTAssertTrue(sut.tableView.isHidden)
		
		sut.displayLoadingIndicator(display: false)
		
		XCTAssertFalse(sut.view.subviews.contains(where: { $0 is UIActivityIndicatorView }))
		XCTAssertFalse(sut.activityIndicator.isAnimating)
		XCTAssertFalse(sut.tableView.isHidden)
	}
	
	// MARK: - Helpers
	
	private func makeSUT(presenter: FlyoversPresenterProtocol = FlyoversPresenterSpy()) -> FlyoversViewController {
		let viewController = FlyoversViewController()
		viewController.presenter = presenter
		_ = UINavigationController(rootViewController: viewController)
		viewController.loadViewIfNeeded()
		return viewController
	}
}
