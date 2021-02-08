//
//  ISSBorderView.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import UIKit

class ISSBorderView: UIView {
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureDefaultUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Configure UI

private extension ISSBorderView {
	func configureDefaultUI() {
		layer.borderWidth = 1
		layer.borderColor = BrandColours.secondary.withAlphaComponent(0.5).cgColor
		layer.cornerRadius = 8
	}
}
