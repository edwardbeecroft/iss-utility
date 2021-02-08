//
//  BaseViewAlertControllerSpy.swift
//  ISSUtilityTests
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import Foundation
@testable import ISSUtility

final class BaseViewAlertControllerSpy: BaseViewAlertController {
	typealias Message = (title: String?, message: String?, actions: [AlertAction])
    var alertMessages = [Message]()
    func showAlert(withTitle title: String?, message: String?, actions: [AlertAction]) {
        alertMessages.append((title, message, actions))
    }
}
