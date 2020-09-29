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
      
    static func fetchData(url: String, responseDataType: ResponseDataType, completion: @escaping (Data) -> ()) {
        guard let url = URL(string: url) else { return }
        switch responseDataType {
        case .json:
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

