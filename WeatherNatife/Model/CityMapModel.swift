//
//  CityMapModel.swift
//  WeatherNatife
//
//  Created by Alex on 04.10.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import Foundation
import  MapKit

class CityMapModel: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var city: String
    var title: String? {
        return city
    }

    init(coordinate: CLLocationCoordinate2D, city: String) {
        self.coordinate = coordinate
        self.city = city
    }
    
}
