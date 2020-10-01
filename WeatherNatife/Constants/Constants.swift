//
//  Constants.swift
//  WeatherNatife
//
//  Created by Alex on 29.09.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import Foundation

// MARK: - API OpenWeather.org
let baseURL = "https://api.openweathermap.org/data/2.5/onecall"
let iconURL = "https://openweathermap.org/img/wn/"
let keyAPI = "d3ec8081dcdadfad7402e334dc5d5756"

// MARK: - API Visicom.ua
let baseVisicomURL = "https://api.visicom.ua/data-api/4.0/ru/search/adm_settlement.json"
let keyVisicomAPI = "9d28529f718acd8aee5f5f22e825977a"

enum ResponseDataType {
    case json
    case jsonCity
    case image
}
