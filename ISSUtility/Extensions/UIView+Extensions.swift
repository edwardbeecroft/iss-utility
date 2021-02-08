//
//  UIView+Extensions.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import UIKit

extension UIView {
	
	// MARK: - Subview Management
	
    func addSubviewForConstraints(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }
	
	// MARK: - Layout Anchors

	var safeTopAnchor: NSLayoutYAxisAnchor {
		return safeAreaLayoutGuide.topAnchor
	}
	
	var safeBottomAnchor: NSLayoutYAxisAnchor {
		return safeAreaLayoutGuide.bottomAnchor
	}
	
	var safeTrailingAnchor: NSLayoutXAxisAnchor {
		return safeAreaLayoutGuide.trailingAnchor
	}
	
	var safeLeadingAnchor: NSLayoutXAxisAnchor {
		return safeAreaLayoutGuide.leadingAnchor
	}
}
