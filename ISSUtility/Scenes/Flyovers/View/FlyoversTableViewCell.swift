//
//  FlyoversTableViewCell.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import UIKit

class FlyoversTableViewCell: UITableViewCell {

	// MARK: - Properties
	
	var flyover: Flyover? {
		didSet {
			guard let flyover = flyover else { return }
			dateLabel.text = flyover.dateString
			timeLabel.text = flyover.timeString
		}
	}

	private let borderView = ISSBorderView()
	private let dateLabel = UILabel()
	private let timeLabel = UILabel()
	
	// MARK: - Lifecycle
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = BrandColours.primary
		backgroundColor = BrandColours.primary
		configureBorderView()
		configureDateLabel()
		configureTimeLabel()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		dateLabel.text?.removeAll()
		timeLabel.text?.removeAll()
	}
}

// MARK: - Configure UI

private extension FlyoversTableViewCell {
	func configureBorderView() {
		contentView.addSubviewForConstraints(borderView)
		NSLayoutConstraint.activate([
			borderView.topAnchor.constraint(equalTo: contentView.safeTopAnchor, constant: UIConstants.smallPadding),
			borderView.leadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor, constant: UIConstants.largePadding),
			borderView.trailingAnchor.constraint(equalTo: contentView.safeTrailingAnchor, constant: -UIConstants.largePadding),
			borderView.bottomAnchor.constraint(equalTo: contentView.safeBottomAnchor, constant: -UIConstants.smallPadding)
		])
	}
	
	func configureDateLabel() {
		dateLabel.font = Fonts.labelRegular
		dateLabel.textColor = BrandColours.secondary
		borderView.addSubviewForConstraints(dateLabel)
		NSLayoutConstraint.activate([
			dateLabel.topAnchor.constraint(equalTo: borderView.safeTopAnchor, constant: UIConstants.largePadding),
			dateLabel.leadingAnchor.constraint(equalTo: borderView.safeLeadingAnchor, constant: UIConstants.largePadding),
			dateLabel.trailingAnchor.constraint(equalTo: borderView.safeTrailingAnchor, constant: -UIConstants.largePadding),
		])
	}

	func configureTimeLabel() {
		timeLabel.font = Fonts.labelRegularLarge
		timeLabel.textColor = BrandColours.secondary
		borderView.addSubviewForConstraints(timeLabel)
		NSLayoutConstraint.activate([
			timeLabel.topAnchor.constraint(equalTo: dateLabel.safeBottomAnchor),
			timeLabel.leadingAnchor.constraint(equalTo: borderView.safeLeadingAnchor, constant: UIConstants.largePadding),
			timeLabel.trailingAnchor.constraint(equalTo: borderView.safeTrailingAnchor, constant: -UIConstants.largePadding),
			timeLabel.bottomAnchor.constraint(equalTo: borderView.safeBottomAnchor)
		])
	}
}
