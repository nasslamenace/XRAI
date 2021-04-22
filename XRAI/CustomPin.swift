//
//  CustomPin.swift
//  XRAI
//
//  Created by Nassim Guettat on 21/04/2021.
//

import UIKit
import MapKit

class CustomPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var id: String?
    var doctor: Doctor?
    init(pinLocation: Doctor, pinTitle: String, pinCoordinate: CLLocationCoordinate2D, pinSubtitle: String, pinId: String) {
        title = pinTitle
        coordinate = pinCoordinate
        subtitle = pinSubtitle
        id = pinId
        doctor = pinLocation
    }
}
