//
//  CityModel.swift
//  WeatherNatife
//
//  Created by Alex on 01.10.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import Foundation

struct CityModel: Decodable {
    let features: [Features]
}

struct Features: Decodable {
    let properties: Properties
    let geoCentroid: GeoCentroid
    
    enum CodingKeys: String, CodingKey {
        case properties
        case geoCentroid = "geo_centroid"
    }
}

struct Properties: Decodable {
    let name: String
    let country: String
    let type: String
}

struct GeoCentroid: Decodable {
    let coordinates: [Double]
}
