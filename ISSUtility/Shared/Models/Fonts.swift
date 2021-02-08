//
//  Fonts.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import UIKit

struct Fonts {
	
	// MARK: - Brand Fonts
	
	static let labelRegular = avenirMedium19
	static let labelRegularLarge = avenirMedium45
	
	// MARK: - Helpers
	
	private static let fontRegularString = "Avenir-Medium"
	private static let fontBoldString = "Avenir-Heavy"
	
	private static let avenirMedium19 = UIFont(name: fontRegularString, size: 19)
	private static let avenirMedium45 = UIFont(name: fontRegularString, size: 45)
}
