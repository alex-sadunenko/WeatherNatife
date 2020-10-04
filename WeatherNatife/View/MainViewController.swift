//
//  MainViewController.swift
//  WeatherNatife
//
//  Created by Alex on 28.09.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import UIKit
import CoreLocation

protocol MapDelegate: class {
    func getCityWeather(city: CityMapModel)
}

class MainViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var collactionView: UICollectionView! {
        didSet {
            collactionView.showsVerticalScrollIndicator = false
            collactionView.showsHorizontalScrollIndicator = false
        }
    }
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let searchVC = segue.source as? SearchViewController else { return }
        cityNameLabel.text = searchVC.currentCity
        longitude = searchVC.currentCoordinate.first
        latitude = searchVC.currentCoordinate.last
        getWeatherByCoordinates()
    }

    //MARK: - Location var
    var locationManager: CLLocationManager!
    var longitude: Double?
    var latitude: Double?
    
    var weather: WeatherModel?
    var currentOrientationIsLandscape = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "#4A90E2")
        configureNavigationBar()
        performLocationManager()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            currentOrientationIsLandscape = true
            heightConstraint.constant = 0
            navigationItem.title = cityNameLabel.text
        } else {
            currentOrientationIsLandscape = false
            heightConstraint.constant = 270
            navigationItem.title = "Погода"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "segueToMapVC" else { return }
        guard let mapVC = segue.destination as? MapViewController else { return }
        mapVC.longitude = longitude
        mapVC.latitude = latitude
        mapVC.delegate = self
    }
}

//MARK: - Map Delegate
extension MainViewController: MapDelegate {
    
    func getCityWeather(city: CityMapModel) {
        cityNameLabel.text = city.city
        longitude = city.coordinate.longitude
        latitude = city.coordinate.latitude
        getWeatherByCoordinates()
    }

}

//MARK: - Configure Navigation Bar
extension MainViewController {
    
    func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
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
        geocoder.reverseGeocodeLocation(userLocation) { [weak self] (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
                self?.displayWarning(title: "Warning", message: "Error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let placemark = placemarks![0]
                self?.cityNameLabel.text = placemark.locality
            }
        }
        
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
        showSpinner()
        LocalManager.shared.getData(url: baseURL + "?lat=\(String(describing: latitude))&lon=\(String(describing: longitude))&units=metric&lang=uk&cnt=1&appid=" + keyAPI, responseDataType: .json) { (weatherModel) in
            DispatchQueue.main.async {
                if let weather = weatherModel as? WeatherModel {
                    self.weather = weather
                    self.dateLabel.text = weather.current.dt.getDate.shortWeekdayDayMonthUppercasedRu
                    self.tempLabel.text = "\(Int(weather.current.temp))\u{00B0}"
                    self.humidityLabel.text = "\(Int(weather.current.humidity)) %"
                    self.windLabel.text = "\(Int(weather.current.windSpeed)) м/сек"
                    if let nameIcon = weather.current.weather.first?.icon {
                        let url = iconURL + "\(nameIcon)@2x.png"
                        LocalManager.shared.getData(url: url, responseDataType: .image) { (imageData) in
                            DispatchQueue.main.async {
                                self.iconImage.image = UIImage(data: imageData as! Data)
                            }
                        }
                    }

                    self.tableView.reloadData()
                    self.collactionView.reloadData()
                }
                self.removeSpinner()
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
        let weatherDay = weather.daily[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DailyTableViewCell
        
        let epocTime = TimeInterval(weatherDay.dt)
        let date = Date(timeIntervalSince1970: epocTime)
        
        cell.dayLabel.text = date.shortWeekdayNameUppercasedRu
        cell.tempLabel.text = "\(Int(weatherDay.temp.min))\u{00B0} / \(Int(weatherDay.temp.max))\u{00B0}"
        
        if let nameIcon = weatherDay.weather.first?.icon {
            let url = iconURL + "\(nameIcon).png"
            LocalManager.shared.getData(url: url, responseDataType: .image) { (imageData) in
                DispatchQueue.main.async {
                    cell.iconImage.image = UIImage(data: imageData as! Data)
                }
            }
        }
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
}

//MARK: - Table View Delegate
extension MainViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // parallax effect
        //let offsetY = -scrollView.contentOffset.y
        //print(offsetY)
        //height.constant = max(50, 200 + offsetY)
    }
    
}

//MARK: - Collection View Data Source
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let weather = weather else { return 0 }
        return weather.hourly.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyCollectionViewCell
        
        guard let weather = weather else { return UICollectionViewCell() }
        let weatherHour = weather.hourly[indexPath.row]

        let epocTime = TimeInterval(weatherHour.dt)
        let date = Date(timeIntervalSince1970: epocTime)

        cell.dayHourLabel.text = "\(date.date24)"
        cell.dayTempLabel.text = String(Int(weatherHour.temp)) + "\u{00B0}"

        if let nameIcon = weatherHour.weather.first?.icon {
            let url = iconURL + "\(nameIcon).png"
            LocalManager.shared.getData(url: url, responseDataType: .image) { (imageData) in
                DispatchQueue.main.async {
                    cell.dayTempImage.image = UIImage(data: imageData as! Data)
                }
            }
        }

        return cell
    }
    
}

