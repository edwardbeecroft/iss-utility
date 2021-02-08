//
//  BaseViewAlertController.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import UIKit

struct AlertAction {
	let title: String?
	let image: UIImage?
	let style: UIAlertAction.Style
	let completion: (() -> Void)?

	init(title: String?, image: UIImage? = nil, style: UIAlertAction.Style = .default, completion: (() -> Void)?) {
		self.title = title
		self.image = image
		self.style = style
		self.completion = completion
	}
}

class AlertController: BaseViewAlertController {
    private weak var view: UIViewController?
	
	init(view: UIViewController) {
        self.view = view
    }
    
    func showAlert(withTitle title: String?,
				   message: String?,
				   actions: [AlertAction]) {
        showController(withTitle: title, message: message, actions: actions, preferredStyle: .alert)
    }
	
	private func showController(withTitle title: String?,
								message: String?,
								actions: [AlertAction],
								preferredStyle: UIAlertController.Style) {
		
		guard let view = view else { return }
		
		let alert = UIAlertController(
			title: title,
			message: message,
			preferredStyle: preferredStyle)
		
		for action in actions {
			alert.addAction(UIAlertAction(
				title: action.title,
				style: action.style,
				handler: { _ in action.completion?() }))
		}
		view.present(alert, animated: true, completion: nil)
	}
}
