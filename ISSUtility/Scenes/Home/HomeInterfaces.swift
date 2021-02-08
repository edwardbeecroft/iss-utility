//
//  HomeInterfaces.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

protocol HomeViewProtocol: AnyObject {
	func display(viewModel: HomeViewModel)
}

protocol HomePresenterProtocol: AnyObject {
	func onViewDidLoad()
	func onTappedFlyovers()
	func onTappedISSLocation()
	func onTappedCompassDirection()
}

protocol HomeRouterProtocol: AnyObject {
	func displayFlyovers()
	func displayISSLocation()
	func displayCompassDirection()
}

struct HomeViewModel {
	let options: [HomeOption]
}

enum HomeOption: CaseIterable {
	case flyovers
	case issLocation
	case issCompassDirection
	
	var title: String {
		switch self {
		case .flyovers:
			return "Flyover"
		case .issLocation:
			return "Where is the ISS?"
		case .issCompassDirection:
			return "Compass Direction to the ISS"
		}
	}
}
