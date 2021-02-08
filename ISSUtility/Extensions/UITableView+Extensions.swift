//
//  UITableView+Extensions.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import UIKit

extension UITableView {
	func registerReusable<T: UITableViewCell>(cellClass: T.Type) {
		register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
	}
	func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        return cell
    }
}
