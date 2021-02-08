//
//  ISSLocationViewController.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import UIKit
import MapKit

class ISSLocationViewController: BaseViewController {

	// MARK: - Properties
	
	private(set) var mapView = MKMapView()
	private(set) var activityIndicator = UIActivityIndicatorView()
	var presenter: ISSLocationPresenterProtocol?
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureNavigationBar()
		configureMapView()
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

private extension ISSLocationViewController {
	func configureNavigationBar() {
		let backButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
		backButtonItem.tintColor = BrandColours.secondary
		navigationItem.leftBarButtonItem = backButtonItem
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.isTranslucent = true
	}
	func configureMapView() {
		mapView.register(ISSMKAnnotationView.self,
						 forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
		mapView.delegate = self
		view.addSubviewForConstraints(mapView)
		NSLayoutConstraint.activate([
			mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}

// MARK: - ISSLocationViewProtocol

extension ISSLocationViewController: ISSLocationViewProtocol {
	func display(viewModel: ISSLocationViewModel) {
		
		mapView.removeAnnotations(mapView.annotations)
		
		let coordinates = viewModel.coordinates
		let latitude = coordinates.latitude
		let longitude = coordinates.longitude
		
		let span = MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 90)
		let coordinateRegion = MKCoordinateRegion(center: coordinates, span: span)
		mapView.setRegion(coordinateRegion, animated: false)
		
		let artwork = ISSMKAnnotation(title: "ISS Location",
									  coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
		
		mapView.addAnnotation(artwork)
		mapView.mapType = MKMapType.standard
		mapView.showsUserLocation = false
	}
	
	func displayLoadingIndicator(display: Bool) {
		mapView.isHidden = display ? true : false
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
	
	func displayISSLocationFetchFailedAlert() {
		showAlert(title: "Network error",
				  message: "We were unable to reach Open Notify's servers. Let's try again?",
				  actionType1: .notNow,
				  actionType2: .retry,
				  completion1: { [weak self] in self?.presenter?.onTappedRetryNotNow() },
				  completion2: { [weak self] in self?.presenter?.onTappedRetry() })
	}
	
	func displayNoConnectivityAlert() {
		showAlert(title: "No connection",
				  message: "It seems you're offline. Please check your connection and try again.",
				  actionType1: .notNow,
				  actionType2: .retry,
				  completion1: { [weak self] in self?.presenter?.onTappedRetryNotNow() },
				  completion2: { [weak self] in self?.presenter?.onTappedRetry() })
	}
}

// MARK: - MKMapViewDelegate

extension ISSLocationViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard let annotation = annotation as? ISSMKAnnotation else { return nil }
		
		let identifier = MKMapViewDefaultAnnotationViewReuseIdentifier
		let view: ISSMKAnnotationView
		if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
		  as? ISSMKAnnotationView {
		  dequeuedView.annotation = annotation
		  view = dequeuedView
		} else {
		  view = ISSMKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
		}
		return view
	}
}

// MARK: - User Actions

private extension ISSLocationViewController {
	@objc func backTapped() {
		presenter?.onTappedBack()
	}
}
