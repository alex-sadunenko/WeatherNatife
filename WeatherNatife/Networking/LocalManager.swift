//
//  LocalManager.swift
//  WeatherNatife
//
//  Created by Alex on 29.09.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import Foundation

class LocalManager {
    
    private init() {}
    static let shared = LocalManager()
    
    public func getData(url: String, responseDataType: ResponseDataType,  completion: @escaping (Any) -> ()) {
        NetworkManager.fetchData(urlString: url, responseDataType: responseDataType) { (data) in
            do {
                switch responseDataType {
                case .json:
                    let result = try JSONDecoder().decode(WeatherModel.self, from: data)
                    completion(result)
                case .jsonCity:
                    let result = try JSONDecoder().decode(CityModel.self, from: data)
                    completion(result)
                case .image:
                    completion(data as Any)
                }
                
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            
        }
    }

}

