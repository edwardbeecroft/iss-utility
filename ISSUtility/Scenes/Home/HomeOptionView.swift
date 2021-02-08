//
//  HomeOptionView.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import UIKit

class HomeOptionView: UIView {
	
	// MARK: - Properties
	
	private let borderView = ISSBorderView()
	private(set) var optionLabel = UILabel()
	private(set) var optionTappedHandler: (() -> Void)
	private(set) var option: HomeOption
	
	// MARK: - Lifecycle
	
	init(homeOption: HomeOption,
		 tapHandler: @escaping () -> Void) {
		option = homeOption
		optionTappedHandler = tapHandler
		super.init(frame: .zero)
		configureBorderView()
		configureOptionLabel()
		configureTapGesture()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Configure UI

private extension HomeOptionView {
	func configureBorderView() {
		addSubviewForConstraints(borderView)
		NSLayoutConstraint.activate([
			borderView.topAnchor.constraint(equalTo: safeTopAnchor),
			borderView.leadingAnchor.constraint(equalTo: safeLeadingAnchor),
			borderView.trailingAnchor.constraint(equalTo: safeTrailingAnchor),
			borderView.bottomAnchor.constraint(equalTo: safeBottomAnchor)
		])
	}
	
	func configureOptionLabel() {
		optionLabel.text = option.title
		optionLabel.textColor = BrandColours.secondary
		optionLabel.font = Fonts.labelRegular
		addSubviewForConstraints(optionLabel)
		NSLayoutConstraint.activate([
			optionLabel.topAnchor.constraint(equalTo: safeTopAnchor, constant: UIConstants.extraLargePadding),
			optionLabel.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: UIConstants.largePadding),
			optionLabel.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -UIConstants.largePadding),
			optionLabel.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -UIConstants.extraLargePadding),
		])
	}
	
	func configureTapGesture() {
		let optionTap = UITapGestureRecognizer(target: self, action: #selector(optionTapped))
		isUserInteractionEnabled = true
		addGestureRecognizer(optionTap)
	}
}

// MARK: - User Actions

private extension HomeOptionView {
	@objc func optionTapped() {
		optionTappedHandler()
	}
}
