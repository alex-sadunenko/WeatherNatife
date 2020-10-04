//
//  SearchViewController.swift
//  WeatherNatife
//
//  Created by Alex on 01.10.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    var timer: Timer?
    var cities: CityModel?
    var currentCity: String = ""
    var currentCoordinate = [Double]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hex: "#4A90E2")
        configureSearchController()
    }

}

// MARK: - Configure Search Controller
extension SearchViewController {
    
    func configureSearchController() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Населенный пункт"
        searchController.searchBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        searchController.searchBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: searchController.searchBar.searchTextField.placeholder ?? "", attributes: [.foregroundColor: UIColor.white])
        definesPresentationContext = true

    }

}

// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            cities = nil
            self.tableView.reloadData()
            return
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (_) in
            LocalManager.shared.getData(url: baseVisicomURL + "?text=\(searchText)&key=\(keyVisicomAPI)", responseDataType: .jsonCity) { (cityModel) in
            self.cities = cityModel as? CityModel
            self.tableView.reloadData()
            }
        })
    }
}

//MARK: - Table View Data Source
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cities = cities else { return 0 }
        return cities.features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cities = cities else { return UITableViewCell() }
        let city = cities.features[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CityTableViewCell
        cell.cityLabel.text = "\(city.properties.name), \(city.properties.type)"
        cell.regionLabel.text = "\(city.properties.country), \(city.properties.level1 ?? ""), \(city.properties.level2 ?? "")"
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
}

//MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cities = cities else { return }
        let city = cities.features[indexPath.row]
        currentCity = city.properties.name
        currentCoordinate = city.geoCentroid.coordinates
        performSegue(withIdentifier: "unwindSegueToMainVC", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

