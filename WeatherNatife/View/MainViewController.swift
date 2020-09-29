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

    @IBOutlet weak var height: NSLayoutConstraint!
    
    //MARK: - Location var
    var locationManager: CLLocationManager!
    var longitude: Double?
    var latitude: Double?

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
        
        guard let _ = latitude, let _ = longitude else { return }
        locationManager.stopUpdatingLocation()

        getAction()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
        getAction()
    }
    
    func getAction() {

//        let baseURLString = "http://api.openweathermap.org/data/2.5/find?lat=\(String(describing: cityViewModel.latitude!))&lon=\(String(describing: cityViewModel.longitude!))&units=metric&lang=uk&cnt=20&appid=d3ec8081dcdadfad7402e334dc5d5756"
//
//        guard let url = URL(string: baseURLString) else { return }
//        let session = URLSession.shared
//        session.dataTask(with: url) { (data, response, error) in
//            guard let _ = response, let data = data else { return }
//
//            let decoder = JSONDecoder()
//            let cities = try? decoder.decode(CitiesModel.self, from: data)
//            self.citiesArray = cities
//
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//
//                self.activity.stopAnimating()
//                self.activity.isHidden = true}
//        }.resume()

    }
}

//MARK: - Table View Data Source
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

//MARK: - Table View Delegate
extension MainViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = -scrollView.contentOffset.y
        height.constant = max(50, 200 + offsetY)
    }
    
}
