//
//  Dictionary+Extensions.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import Foundation

extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
	var jsonData: Data? {
		return try? JSONSerialization.data(withJSONObject: self, options: .init(rawValue: 0))
	}
}
