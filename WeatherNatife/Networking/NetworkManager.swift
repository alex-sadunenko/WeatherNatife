//
//  NetworkManager.swift
//  WeatherNatife
//
//  Created by Alex on 29.09.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
      
    static func fetchData(urlString: String, responseDataType: ResponseDataType, completion: @escaping (Data) -> ()) {
        guard let url = URL(string: urlString.encodeUrl) else { return }
        switch responseDataType {
        case .json, .jsonCity, .jsonFeature:
            AF.request(url).responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let data = response.data else { return }
                    completion(data)
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        case .image:
            AF.request(url).responseData { (response) in
                switch response.result {
                case .success:
                    guard let data = response.data else { return }
                    completion(data)
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

