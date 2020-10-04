//
//  MapViewController.swift
//  WeatherNatife
//
//  Created by Alex on 29.09.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    weak var delegate: MainViewController?
    
    //MARK: - Location var
    var longitude: Double?
    var latitude: Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "#4A90E2")
        prepareGesture()
    }

}

//MARK: - Map View Delegate
extension MapViewController: MKMapViewDelegate {
    
    func prepareGesture() {
        mapView.delegate = self
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
        
        guard let latitude = latitude, let longitude = longitude else { return }
        mapView.showsUserLocation = true
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func longTap(sender: UIGestureRecognizer){
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            print(locationOnMap.latitude)
            print(locationOnMap.longitude)
            addAnnotation(location: locationOnMap)
        }
    }
    
    func addAnnotation(location: CLLocationCoordinate2D){
        LocalManager.shared.getData(url: baseVisicomURL + "?n=\(location.longitude),\(location.latitude)&l=1&key=\(keyVisicomAPI)", responseDataType: .jsonFeature) { (cityFeature) in
            print(cityFeature)
            let city = cityFeature as? Features
            let annotation = CityMapModel(coordinate: location, city: (city?.properties.name)!)
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CityMapModel else { return nil }
        var viewMarker: MKMarkerAnnotationView
        let identifierView = "marker"
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifierView) as? MKMarkerAnnotationView {
            view.annotation = annotation
            viewMarker = view
        } else {
            viewMarker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifierView)
            viewMarker.canShowCallout = true
            viewMarker.calloutOffset = CGPoint(x: 0, y: 6)
            viewMarker.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return viewMarker
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let sityMap = view.annotation as! CityMapModel
        delegate?.getCityWeather(city: sityMap)
        navigationController?.popViewController(animated: true)
    }
}
