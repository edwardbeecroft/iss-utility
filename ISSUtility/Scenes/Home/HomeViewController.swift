//
//  HomeViewController.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

	// MARK: - Properties
	
	private(set) var stackView = UIStackView()
	var presenter: HomePresenterProtocol?
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureStackView()
		presenter?.onViewDidLoad()
	}
}

// MARK: - Configure UI

private extension HomeViewController {
	func configureStackView() {
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.spacing = UIConstants.largePadding
		view.addSubviewForConstraints(stackView)
		NSLayoutConstraint.activate([
			stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
			stackView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: UIConstants.largePadding),
			stackView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -UIConstants.largePadding),
		])
	}
}

// MARK: - HomeViewProtocol

extension HomeViewController: HomeViewProtocol {
	func display(viewModel: HomeViewModel) {
		viewModel.options.forEach({
			var tap: (() -> Void)
			switch $0 {
			case .flyovers:
				tap = flyoverTapped
			case .issLocation:
				tap = issLocationTapped
			case .issCompassDirection:
				tap = compassDirectionTapped
			}
			let optionView = HomeOptionView(homeOption: $0, tapHandler: tap)
			stackView.addArrangedSubview(optionView)
		})
	}
}

// MARK: - User Actions

private extension HomeViewController {
	@objc func flyoverTapped() {
		presenter?.onTappedFlyovers()
	}
	@objc func issLocationTapped() {
		presenter?.onTappedISSLocation()
	}
	@objc func compassDirectionTapped() {
		presenter?.onTappedCompassDirection()
	}
}
