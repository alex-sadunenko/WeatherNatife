//
//  SearchViewController.swift
//  WeatherNatife
//
//  Created by Alex on 01.10.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    
    let searchController = UISearchController(searchResultsController: nil)
    private var timer: Timer?
    var cities: CityModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hex: "#4A90E2")
        configureSearchController()
    }

}

// MARK: - Configure Search Controller
extension SearchViewController {
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Населенный пункт"
        searchController.searchBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: searchController.searchBar.searchTextField.placeholder ?? "", attributes: [.foregroundColor: UIColor.white])
        searchController.searchBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }

}

// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("UISearchBarDelegate " + searchText)
        if searchText.isEmpty {
            return
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (_) in            LocalManager.shared.getData(url: baseVisicomURL + "?text=\(searchText)&key=\(keyVisicomAPI)", responseDataType: .jsonCity) { (cityModel) in
                print(cityModel)
                //self?.tracks = searchResults?.results ?? []
                //self?.tableView.reloadData()
            }
        })
    }
}

//MARK: - Search Controller Delegate
extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        print("UISearchResultsUpdating " + searchText)
//        switch segmentControl.selectedSegmentIndex {
//        case 0:
//            codeTextView.becomeFirstResponder()
//            filteredProduct = productArray.filter({ (products: Product) -> Bool in
//                return products.date.lowercased().contains(searchText.lowercased())
//            })
//        case 1:
//            filteredProduct = productArray.filter({ (products: Product) -> Bool in
//                return products.description.lowercased().contains(searchText.lowercased())
//            })
//        case 2:
//            filteredProduct = productArray.filter({ (products: Product) -> Bool in
//                return products.isCheck == switchControl.isOn
//            })
//        default:
//            return
//        }
//
//        tableView.reloadData()
    }
    
}
