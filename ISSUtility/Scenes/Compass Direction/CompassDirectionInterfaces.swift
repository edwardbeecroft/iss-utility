//
//  CompassDirectionInterfaces.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol CompassDirectionViewProtocol: AnyObject {
	func display(viewModel: CompassDirectionViewModel)
	func displayLoadingIndicator(display: Bool)
	func displayLocationPermissionsRequiredAlert()
	func displayLocationFetchFailedAlert()
	func displayISSLocationFetchFailedAlert()
	func displayNoConnectivityAlert()
}

protocol CompassDirectionPresenterProtocol: AnyObject {
	func onViewDidLoad()
	func onTappedRetryGetLocation()
	func onTappedRetryNotNow()
	func onTappedBack()
}

protocol CompassDirectionParentRouterProtocol: AnyObject {
	func compassDirectionFlowComplete(_ router: RouterProtocol)
}

protocol CompassDirectionRouterProtocol: AnyObject {
	func popCompassDirectionView()
}

struct CompassDirectionViewModel {
	let userLocation: String
	let issLocation: String
	let angleInRadians: CGFloat
}
