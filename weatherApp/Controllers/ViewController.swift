//
//  ViewController.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 15/09/1447 AH.
//
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate,CLLocationManagerDelegate {
    
    var hasShownCityTitle = false
    var isShowingSearch = false
    var selectedCity: String = "Jeddah"
    private let viewModel = WeatherViewModel()
    var hourlyForecast: [ForecastItem] = []
    let locationManager = CLLocationManager()
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var currentInfoView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weatherBackgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ""
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        weatherBackgroundImageView.contentMode = .scaleToFill
          updateBackground()
        fetchCurrentWeather(for: selectedCity)
        fetchForecast(for: selectedCity)
        
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
           setupLoadingIndicator()
    
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
    
    func fetchCurrentWeather(for city: String){
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
        }
        viewModel.loadCurrentWeather(for: city)  { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success :
                DispatchQueue.main.async {
                    guard let data = self.viewModel.currentWeather else { return }
                    self.loadingIndicator.stopAnimating()
                    self.selectedCity = data.name
                    self.cityLabel.text = self.selectedCity
                    self.tempLabel.text = "\(Int(data.main.temp))°"
                    self.conditionLabel.text =
                        WeatherType(rawValue: data.weather.first?.main ?? "")?.text ?? "Clear"
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorAlert(message: error.localizedDescription)
                }
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
            self.searchBar.text = city
            self.fetchCurrentWeather(for: city)
            self.fetchForecast(for: city)
            
           
            
        }
        
        searchVC.onDismiss = { [weak self] in
            self?.isShowingSearch = false
            self?.searchBar.resignFirstResponder()
        }
        
        navigationController?.pushViewController(searchVC, animated: true)
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
            return 500
        } else {
            return 350
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 else { return }
        let detailVC = WeatherDetailViewController(nibName: "WeatherDetailViewController", bundle: nil)
        detailVC.forecastItems = viewModel.forecast?.list ?? []
        present(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyCell
        
        let item = hourlyForecast[indexPath.item]

        cell.configure(with: item)
        if indexPath.item == 0 {
                cell.timeLabel.text = "Now"
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = WeatherDetailViewController(nibName: "WeatherDetailViewController", bundle: nil)
        detailVC.forecastItems = viewModel.forecast?.list ?? []
        present(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 70, height: 120)
    }
    
    func updateBackground() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        if hour >= 6 && hour < 18 {
            weatherBackgroundImageView.image = UIImage(named: "background")
             } else {
            weatherBackgroundImageView.image = UIImage(named: "nightbackground")
                }    }
    
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
    func fetchForecast(for city: String) {
        viewModel.loadForecast(for: city) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                DispatchQueue.main.async {
                    guard let forecastList = self.viewModel.forecast?.list else { return }

                    self.hourlyForecast = Array(forecastList.prefix(8))
                    self.tableView.reloadData()
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    func setupLoadingIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.color = .white
        loadingIndicator.hidesWhenStopped = true

        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
  
}
