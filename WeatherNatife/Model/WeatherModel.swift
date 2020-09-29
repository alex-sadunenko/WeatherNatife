//
//  WeatherModel.swift
//  WeatherNatife
//
//  Created by Alex on 29.09.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import Foundation

struct WeatherModel: Decodable {
    let list: [List]
}

struct List: Decodable {
    let id: Int
    let name: String
    let coord: Coord
    let main: Main
    let dt: Int
    let weather: [Weather]
}

struct Coord: Decodable {
    let lat: Double
    let lon: Double
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let main: String
    let description: String
    let icon: String
}
