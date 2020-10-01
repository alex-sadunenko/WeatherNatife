//
//  DateFormatter.swift
//  WeatherNatife
//
//  Created by Alex on 30.09.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import Foundation

//MARK: - extension Date
extension Date {
    
    var date24: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let dateAsString = dateFormatter.string(from: self as Date)

        let dateFromString = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.date(from: dateAsString)

        return dateFormatter.string(from: dateFromString!)
    }
    
    var shortWeekdayNameUppercasedRu: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        dateFormatter.locale = Locale.init(identifier: "ru_RU_POSIX")
        return dateFormatter.string(from: self as Date).uppercased()
    }
    
}
