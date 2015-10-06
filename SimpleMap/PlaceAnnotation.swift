//
//  PlaceAnnotation.swift
//  SimpleMap
//
//  Created by Nick Chen on 10/5/15.
//  Copyright © 2015 Nick Chen. All rights reserved.
//

import UIKit
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var url: NSURL?
    var phone: String?
    
    var subtitle: String? {
        if let url = url {
            return "\(url)"
        } else {
            return phone
        }
    }

    init(coordinate: CLLocationCoordinate2D, title: String?, url: NSURL?, phone: String?) {
        self.coordinate = coordinate
        self.title = title
        self.url = url
        self.phone = phone
    }
}
