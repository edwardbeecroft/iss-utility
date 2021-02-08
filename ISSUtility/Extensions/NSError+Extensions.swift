//
//  NSError+Extensions.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import Foundation

extension NSError {
	static var generic: NSError {
		return NSError(domain: "General", code: 999, userInfo: nil)
	}
}
