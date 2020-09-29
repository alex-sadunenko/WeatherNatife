//
//  MainViewController.swift
//  WeatherNatife
//
//  Created by Alex on 28.09.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    //MARK: - Location var
    var locationManager: CLLocationManager!
    var longitude: Double?
    var latitude: Double?
    
    var weather: WeatherModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        performLocationManager()
    }
    
}

//MARK: - Location delegate methods
extension MainViewController: CLLocationManagerDelegate {
    
    func performLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
            }
        }
        
        //guard let _ = latitude, let _ = longitude else { return }
        if latitude != nil && longitude != nil {
            locationManager.stopUpdatingLocation()
            getWeatherByCoordinates()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error.localizedDescription)")
    }
    
    func getWeatherByCoordinates() {
        
        guard let latitude = latitude, let longitude = longitude else { return }
        //showSpinner()
        LocalManager.shared.getData(url: baseURL + "?lat=\(String(describing: latitude))&lon=\(String(describing: longitude))&units=metric&lang=uk&cnt=1&appid=" + keyAPI, responseDataType: .json) { (weatherModel) in
            DispatchQueue.main.async {
                self.weather = weatherModel as? WeatherModel
                print(weatherModel)
                //let weatherRasponse =
                //let newsResponse = NewsResponse.init(withNews: newsModel as! NewsModel)
                //self.news = newsResponse.news
                self.tableView.reloadData()
                //self.removeSpinner()
            }
            
        }

    }
}

//MARK: - Table View Data Source
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let weather = weather else { return 0 }
        return weather.daily.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let weather = weather else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DailyTableViewCell
        
        let formatter = DateFormatter();
        formatter.dateFormat = "EE"
        formatter.locale = Locale.init(identifier: "ru_UA")
        let epocTime = TimeInterval(weather.daily[indexPath.row].dt)
        let date = Date(timeIntervalSince1970: epocTime)
        
        cell.dayLabel.text = formatter.string(from: date).uppercased()
        cell.tempLabel.text = "\(Int(weather.daily[indexPath.row].temp.min))\u{00B0} / \(Int(weather.daily[indexPath.row].temp.max))\u{00B0}"
        return cell
    }
    
}

//MARK: - Table View Delegate
extension MainViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = -scrollView.contentOffset.y
        print(offsetY)
        //height.constant = max(50, 200 + offsetY)
    }
    
}
