//
//  WeatherModel.swift
//  WeatherNatife
//
//  Created by Alex on 29.09.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import Foundation

struct WeatherModel: Decodable {
    let hourly: [Hourly]
    let daily: [Daily]
}

struct Hourly: Decodable {
    let dt: Int
    let temp: Double
    let feels_like: Double
    let pressure: Double
    let wind_speed: Double
    let weather: [Weather]
}

struct Daily: Decodable {
    let dt: Int
    let temp: TempDaily
    let weather: [Weather]
}

struct TempDaily: Decodable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
}

struct Weather: Decodable {
    let main: String
    let description: String
    let icon: String
}
