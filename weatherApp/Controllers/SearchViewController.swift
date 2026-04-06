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
    
    let cities = [
        "Riyadh",
        "Jazan",
        "Makkah",
        "Madinah",
        "Dammam",
        "Khobar",
        "Dhahran",
        "Taif",
        "Tabuk",
        "Abha",
        "Khamis Mushait",
        "Najran",
        "Al Baha",
        "Hail",
        "Buraidah",
        "Unaizah",
        "Arar",
        "Sakaka",
        "Yanbu",
        "Rabigh",
        "Al Jubail",
        "Al Ahsa",
        "Hofuf",
        "Qatif",
        "Ras Tanura",
        "Khafji",
        "Buqayq",
        "Al Nairyah",
        "Qaryat al Ulya",
        "Udhailiyah",
        "Safwa",
        "Saihat",
        "Tarout",
        "Diriyah",
        "Al Kharj",
        "Al Majma'ah",
        "Al Zulfi",
        "Shaqra",
        "Afif",
        "Dawadmi",
        "Wadi Al Dawasir",
        "Sulayyil",
        "Al Aflaj",
        "Huraymila",
        "Rumah",
        "Thadiq",
        "Hotat Bani Tamim",
        "Al Hariq",
        "Layla",
        "Marat",
        "Ad Dilam",
        "Al Quwayiyah",
        "Muzahimiyah",
        "Bisha",
        "Baljurashi",
        "Al Mandaq",
        "Muhayil Asir",
        "Ahad Rafidah",
        "Sarat Abidah",
        "Rijal Alma",
        "Tanomah",
        "Al Namas",
        "Dhahran Al Janub",
        "Sabya",
        "Abu Arish",
        "Samtah",
        "Bish",
        "Al Ardah",
        "Darb",
        "Farasan",
        "Sharurah",
        "Habuna",
        "Yadamah",
        "Badr Al Janub",
        "Al Ula",
        "Khaybar",
        "Badr",
        "Mahd Al Dhahab",
        "Al Hanakiyah",
        "Al Uyaynah",
        "Tayma",
        "Duba",
        "Al Wajh",
        "Umluj",
        "Haql",
        "Al Qunfudhah",
        "Al Lith",
        "Turabah",
        "Ranyah",
        "Al Jamum",
        "Al Kamil",
        "Al Khurmah",
        "Al Mowaih",
        "Thuwal",
        "Jizan Economic City",
        "Al Qurayyat",
        "Turaif",
        "Rafha",
        "Domat Al Jandal",
        "Tabarjal",
        "Al Jawf",
        "Hafar Al Batin",
        "Qaisumah",
        "Al Artawiyah",
        "Madinat as Sina'iyah",
        "Al Mithnab",
        "Al Bukayriyah",
        "Ar Rass",
        "Al Badayea",
        "Riyadh Al Khabra",
        "Uqlat As Suqur",
        "Dulay Rasheed",
        "Al Khabra",
        "As Sulayyil",
        "Al Shamli",
        "Baqaa",
        "Al Ghazalah",
        "Ash Shinan",
        "Mawqaq",
        "Samirah",
        "Jubbah",
        "Al Hait"
    ]
    
    var filteredCities: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredCities = []
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.isOpaque = false
        tableView.separatorStyle = .none
        
        searchBar.delegate = self
        searchBar.searchTextField.text = initialSearchText
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        searchBar.isOpaque = false
        
        applySearchAppearance()
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
        
        view.applyWeatherGradient(colors: WeatherTheme.colors(isDay: isDay))
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
        
        view.applyWeatherGradient(colors: WeatherTheme.colors(isDay: isDay))
        
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
            
            let identifier = "CityCell"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            ?? UITableViewCell(style: .default, reuseIdentifier: identifier)
            
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
    

