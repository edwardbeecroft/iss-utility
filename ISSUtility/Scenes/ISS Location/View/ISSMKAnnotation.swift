//
//  ISSMKAnnotation.swift
//  ISSUtility
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import UIKit
import MapKit

class ISSMKAnnotation: NSObject, MKAnnotation {
	var title: String?
	var subtitle: String?
	let coordinate: CLLocationCoordinate2D
	
	init(title: String, coordinate: CLLocationCoordinate2D) {
		self.title = title
		subtitle = "Lat: \(coordinate.latitude), Long: \(coordinate.longitude)"
		self.coordinate = coordinate
		super.init()
	}
}

class ISSMKAnnotationView: MKAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      image = UIImage(named: "iss-icon")
    }
  }
}
