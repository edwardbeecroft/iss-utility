//
//  MockNavigationController.swift
//  ISSUtilityTests
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import UIKit
@testable import ISSUtility

final class MockNavigationController: UINavigationController {
	
	private var _viewControllers = [UIViewController]()
	
	override var viewControllers: [UIViewController] {
		get {
			return _viewControllers
		}
		set {
			_viewControllers = newValue
		}
	}
	
	override var visibleViewController: UIViewController? {
		return _viewControllers.last
	}
	
	override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
		_viewControllers = viewControllers
		super.setViewControllers(viewControllers, animated: false)
	}
	
	override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		_viewControllers.append(viewController)
		super.pushViewController(viewController, animated: false)
	}
	
	override func popViewController(animated: Bool) -> UIViewController? {
		_ = _viewControllers.popLast()
		return super.popViewController(animated: animated)
	}
}
