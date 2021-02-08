//
//  BaseViewController.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import UIKit

enum ActionType: String {
    case notNow = "Not Now"
	case retry = "Retry"
	case goToSettings = "Go to settings"
}

protocol BaseViewProtocol: class {
    func didPressBack()
}

protocol BaseViewAlertController {
    func showAlert(withTitle: String?, message: String?, actions: [AlertAction])
}

class BaseViewController: UIViewController {
	lazy var alertController: BaseViewAlertController = AlertController(view: self)

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = BrandColours.primary
    }
    
	func showAlert(title: String,
				   message: String,
				   actionType1 action1: ActionType,
				   actionType2 action2: ActionType,
				   completion1: (() -> Void)?,
				   completion2: (() -> Void)? = nil) {
		
		let actions: [AlertAction] = [
			AlertAction(title: action1.rawValue,
						completion: completion1),
			AlertAction(title: action2.rawValue,
						completion: completion2)
		]
		alertController.showAlert(withTitle: title, message: message, actions: actions)
    }
}
