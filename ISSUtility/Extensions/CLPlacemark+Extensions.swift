//
//  CLPlacemark+Extensions.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import CoreLocation
import Contacts

extension CLPlacemark {
    func makeAddressString() -> String {
		let thoroughFareString = [subThoroughfare, thoroughfare].compactMap({ $0 }).joined(separator: " ")
        return [thoroughFareString, locality, postalCode]
			.compactMap({ $0 })
            .joined(separator: ", ")
    }
}
