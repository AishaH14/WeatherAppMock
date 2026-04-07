//
//  SearchViewController.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 28/09/1447 AH.
//


import UIKit

class SearchViewController: UIViewController   {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var initialSearchText: String = ""
    var onDismiss: (() -> Void)?
    var onCitySelected: ((String) -> Void)?
 
    var filteredCities: [String] = []
    var cities: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.isOpaque = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CityCell")
        searchBar.delegate = self
        searchBar.searchTextField.text = initialSearchText
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        searchBar.isOpaque = false
        
        applySearchAppearance()
        loadCities()
        filterCities(with: initialSearchText)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(close)
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applySearchAppearance()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let hour = Calendar.current.component(.hour, from: Date())
        let isDay = hour >= 6 && hour < 18
        
        view.applyWeatherGradient(isDay: isDay)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onDismiss?()
    }
    
    func applySearchAppearance() {
        let hour = Calendar.current.component(.hour, from: Date())
        let isDay = hour >= 6 && hour < 18
        
        view.applyWeatherGradient(isDay: isDay)
        
        tableView.backgroundColor = .clear
        tableView.isOpaque = false
        
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        searchBar.isOpaque = false
        
        let textField = searchBar.searchTextField
        textField.layer.cornerRadius = 18
        textField.clipsToBounds = true
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.14)
        textField.textColor = .white
        textField.tintColor = .white
        textField.leftView?.tintColor = UIColor.white.withAlphaComponent(0.8)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search city",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.65)]
        )
        
    }
    
    func filterCities(with text: String) {
        let keyword = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if keyword.isEmpty {
            filteredCities = []
        } else {
            filteredCities = cities.filter {
                $0.lowercased().contains(keyword.lowercased())
            }
        }
        
        tableView.reloadData()
    }
    @objc func close() {
        navigationController?.popViewController(animated: true)
    }
    func loadCities() {
        guard let url = Bundle.main.url(forResource: "cities", withExtension: "json") else {
            print("cities.json not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            cities = try JSONDecoder().decode([String].self, from: data)
        } catch {
            print("Failed to load cities: \(error)")
        }
    }
}

    extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterCities(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        guard !text.isEmpty else { return }
        
        onCitySelected?(text)
        dismiss(animated: true)
    }
}
    extension SearchViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredCities.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
            
           
            
            var content = cell.defaultContentConfiguration()
            content.text = filteredCities[indexPath.row]
            content.textProperties.color = .white
            
            cell.contentConfiguration = content
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.selectionStyle = .none
            
            return cell
        }
    }
    extension SearchViewController: UITableViewDelegate {
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let selectedCity = filteredCities[indexPath.row]
                onCitySelected?(selectedCity)
                navigationController?.popViewController(animated: true)
            }
            
        }
    

