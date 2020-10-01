//
//  String.swift
//  WeatherNatife
//
//  Created by Alex on 01.10.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import Foundation

extension String{
    
    var encodeUrl: String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    var decodeUrl: String {
        return self.removingPercentEncoding!
    }
}
