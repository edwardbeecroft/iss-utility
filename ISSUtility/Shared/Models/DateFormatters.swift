//
//  DateFormatters.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import Foundation

struct DateFormatters {
	static var longDateFormatter: DateFormatter {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEE dd MMM YYYY"
		dateFormatter.locale = Locale.current
		dateFormatter.timeZone = TimeZone.current
		return dateFormatter
	}
	static var timeFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm"
		return formatter
	}
}
