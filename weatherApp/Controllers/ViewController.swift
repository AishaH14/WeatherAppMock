//
//  ViewController.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 15/09/1447 AH.
//
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var hasShownCityTitle = false
    var isShowingSearch = false
    var selectedCity: String = "Jeddah"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var currentInfoView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weatherBackgroundImageView: UIImageView!

    let weatherService = WeatherService()
    var weatherData: WeatherResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ""
        
        weatherBackgroundImageView.contentMode = .scaleToFill
          updateBackground()
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        tableView.register(UINib(nibName: "HourlySectionCell", bundle: nil),
                           forCellReuseIdentifier: "HourlySectionCell")
        
        tableView.register(UINib(nibName: "DailyForecastCell", bundle: nil),
                           forCellReuseIdentifier: "DailyForecastCell")
        
        tableView.register(UINib(nibName: "WeatherInfoCell", bundle: nil),
                           forCellReuseIdentifier: "WeatherInfoCell")
        
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        setupSearchBar()
        fetchWeather()
    
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        searchBar.text = ""
        
        let textField = searchBar.searchTextField
        textField.layer.cornerRadius = 18
        textField.clipsToBounds = true
        textField.textColor = .white
        textField.tintColor = .white
        
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search city",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.65)]
        )

        textField.leftView?.tintColor = UIColor.white.withAlphaComponent(0.8)
    }
    
    func fetchWeather() {
        weatherService.fetchWeather { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.weatherData = data
                    self?.tableView.reloadData()
                    self?.cityLabel.text = self?.selectedCity
                    self?.tempLabel.text = "\(Int(data.current.temp))°"
                    self?.conditionLabel.text = data.current.weather.first?.main
                }
                
            case .failure(let error):
                print("Error fetching weather:", error.localizedDescription)
            }
        }
    }
    
    func openSearchScreen(initialText: String = "") {
        guard !isShowingSearch else { return }
        isShowingSearch = true
        
        let searchVC = SearchViewController(nibName: "SearchViewController", bundle: nil)
        searchVC.modalPresentationStyle = .fullScreen
        searchVC.initialSearchText = initialText
        
        searchVC.onCitySelected = { [weak self] city in
            guard let self = self else { return }
            self.selectedCity = city
            self.cityLabel.text = city
            self.searchBar.text = city
            
           
            self.fetchWeather()
        }
        
        searchVC.onDismiss = { [weak self] in
            self?.isShowingSearch = false
            self?.searchBar.resignFirstResponder()
        }
        
        present(searchVC, animated: true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        openSearchScreen(initialText: searchBar.text ?? "")
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlySectionCell", for: indexPath) as! HourlySectionCell
            
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.register(UINib(nibName: "HourlyCell", bundle: nil),
                                         forCellWithReuseIdentifier: "HourlyCell")
            cell.collectionView.reloadData()
            
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyForecastCell", for: indexPath) as! DailyForecastCell
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherInfoCell", for: indexPath) as! WeatherInfoCell
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 160
        } else if indexPath.row == 1 {
            return 380
        } else {
            return 350
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = WeatherDetailViewController(nibName: "WeatherDetailViewController", bundle: nil)
        present(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyCell
        
        cell.timeLabel.text = "3PM"
        cell.tempLabel.text = "32°"
        cell.weatherImage.image = UIImage(systemName: "sun.max.fill")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 70, height: 120)
    }
    
    func updateBackground() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        if hour >= 6 && hour < 18 {
            view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        } else {
            view.backgroundColor = UIColor(patternImage: UIImage(named: "nightbackground")!)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y + tableView.contentInset.top
        let progress = min(max(yOffset / 80, 0), 1)

        tempLabel.alpha = 1 - progress
        conditionLabel.alpha = 1 - progress

        let moveY = -20 * progress
        tempLabel.transform = CGAffineTransform(translationX: 0, y: moveY)
        conditionLabel.transform = CGAffineTransform(translationX: 0, y: moveY)

        cityLabel.transform = .identity
        cityLabel.alpha = 1

        navigationItem.title = ""
    }
}
