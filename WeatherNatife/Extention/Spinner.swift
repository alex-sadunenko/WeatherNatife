//
//  Spinner.swift
//  WeatherNatife
//
//  Created by Alex on 29.09.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import Foundation
import UIKit

var spinnerView = UIView()
var indicatorActivity = UIActivityIndicatorView()

extension UIViewController {
    
    func showSpinner() {
        spinnerView = UIView(frame: self.view.bounds)
        indicatorActivity = UIActivityIndicatorView(style: .large)
        indicatorActivity.center = spinnerView.center
        indicatorActivity.startAnimating()
        indicatorActivity.isHidden = false
        spinnerView.addSubview(indicatorActivity)
        self.view.addSubview(spinnerView)
    }
    
    func removeSpinner() {
        indicatorActivity.stopAnimating()
        indicatorActivity.isHidden = true
        spinnerView.removeFromSuperview()
    }
    
}
