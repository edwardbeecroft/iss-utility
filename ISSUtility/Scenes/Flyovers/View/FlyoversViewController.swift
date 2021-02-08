//
//  FlyoversViewController.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import UIKit

class FlyoversViewController: BaseViewController {

	// MARK: - Properties
	
	var presenter: FlyoversPresenterProtocol?
	private(set) var tableView = UITableView()
	private(set) var locationLabel = UILabel()
	private(set) var activityIndicator = UIActivityIndicatorView()
	private(set) var flyovers = [Flyover]()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureNavigationBar()
		configureLocationLabel()
		configureTableView()
		presenter?.onViewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
}

// MARK: - Configure UI

private extension FlyoversViewController {
	func configureNavigationBar() {
		let backButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
		backButtonItem.tintColor = BrandColours.secondary
		navigationItem.leftBarButtonItem = backButtonItem
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.isTranslucent = true
	}
	
	func configureLocationLabel() {
		locationLabel.font = Fonts.labelRegular
		locationLabel.textColor = BrandColours.secondary
		locationLabel.numberOfLines = 0
		locationLabel.lineBreakMode = .byWordWrapping
		locationLabel.textAlignment = .center
		view.addSubviewForConstraints(locationLabel)
		NSLayoutConstraint.activate([
			locationLabel.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: UIConstants.largePadding),
			locationLabel.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -UIConstants.largePadding),
			locationLabel.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -UIConstants.largePadding)
		])
	}
	
	func configureTableView() {
		tableView.backgroundColor = BrandColours.primary
		tableView.estimatedRowHeight = 50
		tableView.rowHeight = UITableView.automaticDimension
		tableView.delegate = self
		tableView.dataSource = self
		tableView.registerReusable(cellClass: FlyoversTableViewCell.self)
		view.addSubviewForConstraints(tableView)
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 40),
			tableView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: locationLabel.topAnchor, constant: -UIConstants.largePadding)
		])
	}
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension FlyoversViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return flyovers.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: FlyoversTableViewCell = tableView.dequeueReusableCell(for: indexPath)
		cell.flyover = flyovers[indexPath.row]
		cell.selectionStyle = .none
		return cell
	}
}

// MARK: - HomeViewProtocol

extension FlyoversViewController: FlyoversViewProtocol {
	func display(viewModel: FlyoversViewModel) {
		locationLabel.text = viewModel.titleString
		flyovers = viewModel.flyovers
		tableView.reloadData()
	}
	
	func displayLoadingIndicator(display: Bool) {
		[locationLabel, tableView].forEach({ $0.isHidden = display ? true : false })
		if display {
			activityIndicator.color = BrandColours.secondary
			view.addSubviewForConstraints(activityIndicator)
			NSLayoutConstraint.activate([
				activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
				activityIndicator.widthAnchor.constraint(equalToConstant: UIConstants.activityIndicatorSize),
				activityIndicator.heightAnchor.constraint(equalToConstant: UIConstants.activityIndicatorSize),
				activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
				])
			activityIndicator.startAnimating()
		} else {
			activityIndicator.stopAnimating()
			activityIndicator.removeFromSuperview()
		}
	}
	
	func displayLocationPermissionsRequiredAlert() {
		showAlert(title: "Location permission",
				  message: "We need permission to access your location",
				  actionType1: .notNow,
				  actionType2: .goToSettings,
				  completion1: { [weak self] in self?.presenter?.onTappedRetryNotNow() },
				  completion2: {
					guard
						let url = URL(string: UIApplication.openSettingsURLString),
						UIApplication.shared.canOpenURL(url) else {
							return
					}
					UIApplication.shared.open(url)
		})
	}
	
	func displayLocationFetchFailedAlert() {
		showAlert(title: "Location error",
				  message: "We were unable to obtain your location. Let's try again?",
				  actionType1: .notNow,
				  actionType2: .retry,
				  completion1: { [weak self] in self?.presenter?.onTappedRetryNotNow() },
				  completion2: { [weak self] in self?.presenter?.onTappedRetryGetLocation() })
	}
	
	func displayFlyoverFetchFailedAlert() {
		showAlert(title: "Network error",
				  message: "We were unable to reach Open Notify's servers. Let's try again?",
				  actionType1: .notNow,
				  actionType2: .retry,
				  completion1: { [weak self] in self?.presenter?.onTappedRetryNotNow() },
				  completion2: { [weak self] in self?.presenter?.onTappedRetryGetLocation() })
	}
	
	func displayNoConnectivityAlert() {
		showAlert(title: "No connection",
				  message: "It seems you're offline. Please check your connection and try again.",
				  actionType1: .notNow,
				  actionType2: .retry,
				  completion1: { [weak self] in self?.presenter?.onTappedRetryNotNow() },
				  completion2: { [weak self] in self?.presenter?.onTappedRetryGetLocation() })
	}
}

// MARK: - User Actions

private extension FlyoversViewController {
	@objc func backTapped() {
		presenter?.onTappedBack()
	}
}
