//
//  CompassDirectionViewController.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import UIKit

class CompassDirectionViewController: BaseViewController {

	// MARK: - Properties
	
	var presenter: CompassDirectionPresenterProtocol?
	private(set) var compassImageView = UIImageView()
	private(set) var issImageView = UIImageView()
	private(set) var userLocationLabel = UILabel()
	private(set) var issLocationLabel = UILabel()
	private(set) var activityIndicator = UIActivityIndicatorView()
	private(set) var flyovers = [Flyover]()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureNavigationBar()
		configureCompassView()
		configureISSImageView()
		configureLocationLabels()
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

private extension CompassDirectionViewController {
	func configureNavigationBar() {
		let backButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
		backButtonItem.tintColor = BrandColours.secondary
		navigationItem.leftBarButtonItem = backButtonItem
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.isTranslucent = true
	}
	
	func configureCompassView() {
		compassImageView.contentMode = .scaleAspectFit
		compassImageView.image = UIImage(named: "compass")
		view.addSubviewForConstraints(compassImageView)
		NSLayoutConstraint.activate([
			compassImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
			compassImageView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: UIConstants.extraLargePadding),
			compassImageView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -UIConstants.extraLargePadding),
			compassImageView.heightAnchor.constraint(equalTo: compassImageView.widthAnchor)
		])
	}
	
	func configureISSImageView() {
		issImageView.contentMode = .scaleAspectFit
		issImageView.image = UIImage(named: "iss-icon")
		view.addSubviewForConstraints(issImageView)
		NSLayoutConstraint.activate([
			issImageView.centerXAnchor.constraint(equalTo: compassImageView.centerXAnchor),
			issImageView.topAnchor.constraint(equalTo: compassImageView.topAnchor, constant: -10),
			issImageView.heightAnchor.constraint(equalToConstant: 40),
			issImageView.widthAnchor.constraint(equalToConstant: 40)
		])
	}
	
	func configureLocationLabels() {
		[userLocationLabel, issLocationLabel].forEach({
			view.addSubviewForConstraints($0)
			$0.font = Fonts.labelRegular
			$0.textColor = BrandColours.secondary
			$0.numberOfLines = 0
			$0.lineBreakMode = .byWordWrapping
			$0.textAlignment = .center
		})
		
		NSLayoutConstraint.activate([
			issLocationLabel.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: UIConstants.extraLargePadding),
			issLocationLabel.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -UIConstants.extraLargePadding),
			issLocationLabel.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -UIConstants.extraLargePadding),
			
			userLocationLabel.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: UIConstants.extraLargePadding),
			userLocationLabel.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -UIConstants.extraLargePadding),
			userLocationLabel.bottomAnchor.constraint(equalTo: issLocationLabel.topAnchor, constant: -UIConstants.smallPadding)
		])
	}
}

// MARK: - CompassDirectionViewProtocol

extension CompassDirectionViewController: CompassDirectionViewProtocol {
	func display(viewModel: CompassDirectionViewModel) {
		self.userLocationLabel.text = viewModel.userLocation
		self.issLocationLabel.text = viewModel.issLocation
		self.performISSRotation(angleInRadians: viewModel.angleInRadians)
	}
	
	func displayLoadingIndicator(display: Bool) {
		[compassImageView,
		 userLocationLabel,
		 issLocationLabel].forEach({ $0.isHidden = display ? true : false })
		if display {
			issImageView.isHidden = true
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
	
	func displayISSLocationFetchFailedAlert() {
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

// MARK: - ISS Rotation Engine

private extension CompassDirectionViewController {
	private func performISSRotation(angleInRadians: CGFloat) {
		DispatchQueue.main.async {
			let myTransform = CGAffineTransform(rotationAngle: angleInRadians)
			self.issImageView.transform = myTransform
			let newPoint = self.rotateISS(angleInRadians: angleInRadians)
			self.issImageView.center = newPoint
			self.issImageView.isHidden = false
		}
	}
	
	private func rotateISS(angleInRadians: CGFloat) -> CGPoint {
		let target = issImageView.center
		let origin = compassImageView.center
		let issDistanceX = target.x - origin.x
		let issDistanceY = target.y - origin.y
		let radius = sqrt(issDistanceX * issDistanceX + issDistanceY * issDistanceY)
		let azimuth = atan2(issDistanceY, issDistanceX)
		let newAzimuth = azimuth + angleInRadians
		let x = origin.x + radius * cos(newAzimuth)
		let y = origin.y + radius * sin(newAzimuth)
		return CGPoint(x: x, y: y)
	}
}

// MARK: - User Actions

private extension CompassDirectionViewController {
	@objc func backTapped() {
		presenter?.onTappedBack()
	}
}
