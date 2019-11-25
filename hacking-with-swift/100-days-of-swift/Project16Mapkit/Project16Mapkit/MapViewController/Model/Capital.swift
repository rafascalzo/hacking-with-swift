//
//  Capital.swift
//  Project16Mapkit
//
//  Created by rafaeldelegate on 11/24/19.
//  Copyright © 2019 rafaeldelegate. All rights reserved.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        super.init()
    }

}
