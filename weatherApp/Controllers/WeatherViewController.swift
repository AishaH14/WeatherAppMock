//
// WeatherViewController.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 15/09/1447 AH.
//
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    var hasShownCityTitle = false
    var isShowingSearch = false
    private let viewModel = WeatherViewModel()
    var hourlyForecast: [ForecastItem] = []
    private var dailyForecastItems: [DailyForecastItem] = []
    let locationManager = CLLocationManager()
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var currentInfoView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weatherBackgroundImageView: UIImageView!
    @IBOutlet private weak var mapButton: UIButton!
    @IBAction private func mapButtonTapped(_ sender: UIButton) {
        openMapScreen()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ""
        locationManager.delegate = self
        handleLocationAuthorization()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        tableView.register(
            UINib(nibName: Constants.hourlySectionCell, bundle: nil),
            forCellReuseIdentifier: Constants.hourlySectionCell
        )
        
        tableView.register(
            UINib(nibName: Constants.dailyForecastCell, bundle: nil),
            forCellReuseIdentifier: Constants.dailyForecastCell
        )
        
        tableView.register(
            UINib(nibName: Constants.weatherInfoCell, bundle: nil),
            forCellReuseIdentifier: Constants.weatherInfoCell
        )
        
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        setupSearchBar()
        setupLoadingIndicator()
        updateBackground()
        loadDailyForecast()
        currentInfoView.isUserInteractionEnabled = true
        currentInfoView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(openWeatherDetail))
        )
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureMapButton()
    }
    func updateBackground() {
        let hour = Calendar.current.component(.hour, from: Date())

        if hour >= 6 && hour < 18 {
            weatherBackgroundImageView.image = UIImage(named: "background")
        } else {
            weatherBackgroundImageView.image = UIImage(named: "nightbackground")
        }
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
    private func handleCurrentWeatherResult(
        _ result: Result<Void, Error>,
        cityName: String? = nil
    ) {
        switch result {
        case .success:
            DispatchQueue.main.async {
                guard let data = self.viewModel.currentWeather else { return }
                self.loadingIndicator.stopAnimating()
                self.cityLabel.text = cityName ?? data.name
                self.tempLabel.text = "\(Int(data.main.temp))°"
                self.conditionLabel.text = data.weather.first?.description.capitalized ?? "Clear"
            }

        case .failure(let error):
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                self.showErrorAlert(message: error.localizedDescription)
            }
        }
    }

    private func handleForecastResult(_ result: Result<Void, Error>) {
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
    func fetchCurrentWeather(for city: String) {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
        }

        viewModel.loadCurrentWeather(for: city) { [weak self] result in
            guard let self = self else { return }
            self.handleCurrentWeatherResult(result, cityName: city)
        }
    }
    func fetchCurrentWeather(lat: Double, lon: Double) {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
        }

        viewModel.loadCurrentWeather(lat: lat, lon: lon) { [weak self] result in
            guard let self = self else { return }
            self.handleCurrentWeatherResult(result)
        }
    }
    func fetchForecast(for city: String) {
        viewModel.loadForecast(for: city) { [weak self] result in
            guard let self = self else { return }
            self.handleForecastResult(result)
        }
    }
    private func loadDailyForecast() {
        Task { [weak self] in
            guard let self = self else { return }

            do {
                self.dailyForecastItems = try await DailyForecastLoader.load()
                self.tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    func fetchForecast(lat: Double, lon: Double) {
        viewModel.loadForecast(lat: lat, lon: lon) { [weak self] result in
            guard let self = self else { return }
            self.handleForecastResult(result)
        }
    }

    func openSearchScreen(initialText: String = "") {
        guard !isShowingSearch else { return }
        isShowingSearch = true

        let searchVC = SearchViewController(nibName: "SearchViewController", bundle: nil)
        searchVC.initialSearchText = initialText

        searchVC.onCitySelected = { [weak self] city in
            guard let self = self else { return }
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

    @objc func openWeatherDetail() {
        let detailVC = WeatherDetailViewController(
            nibName: "WeatherDetailViewController",
            bundle: nil
        )
        detailVC.forecastItems = viewModel.forecast?.list ?? []

        present(detailVC, animated: true) {
            detailVC.showCalendarPopup()
        }
    }

    func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func loadFallbackCity() {
        cityLabel.text = "Select a city"
        tempLabel.text = "--"
        conditionLabel.text = "Location unavailable"
        hourlyForecast = []
        tableView.reloadData()
    }

    private func handleLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            loadFallbackCity()
        @unknown default:
            loadFallbackCity()
        }
        
    }
    private func openMapScreen() {
    let mapViewController = MapViewController()
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    private func configureMapButton() {
        mapButton.layoutIfNeeded()
        mapButton.layer.cornerRadius = mapButton.bounds.height / 2
        mapButton.clipsToBounds = true
        mapButton.backgroundColor = UIColor.white.withAlphaComponent(0.3)
    }
}

extension WeatherViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        openSearchScreen(initialText: searchBar.text ?? "")
        return false
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeatherRow.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = WeatherRow(rawValue: indexPath.row) else {
            return UITableViewCell()
        }

        switch row {
        case .hourly:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.hourlySectionCell,
                for: indexPath
            ) as? HourlySectionCell else {
                return UITableViewCell()
            }

            cell.configure(with: hourlyForecast)
            cell.onTapHourly = { [weak self] in
                guard let self = self else { return }
                let detailVC = WeatherDetailViewController(
                    nibName: "WeatherDetailViewController",
                    bundle: nil
                )
                detailVC.forecastItems = self.viewModel.forecast?.list ?? []
                self.present(detailVC, animated: true)
            }
            return cell

        case .dailyForecast:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.dailyForecastCell,
                for: indexPath
            ) as? DailyForecastCell else {
                return UITableViewCell()
            }
            cell.configure(with: dailyForecastItems)
            return cell

        case .weatherInfo:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.weatherInfoCell,
                for: indexPath
            ) as? WeatherInfoCell else {
                return UITableViewCell()
            }

            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            return cell
        }
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let row = WeatherRow(rawValue: indexPath.row) else {
            return 0
        }

        switch row {
        case .hourly:
            return 160
        case .dailyForecast:
            return 500
        case .weatherInfo:
            return 350
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

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            loadFallbackCity()
            return
        }

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        fetchCurrentWeather(lat: latitude, lon: longitude)
        fetchForecast(lat: latitude, lon: longitude)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        loadFallbackCity()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            loadFallbackCity()
        case .notDetermined:
            break
        @unknown default:
            loadFallbackCity()
        }
    }
}

private enum WeatherRow: Int, CaseIterable {
    case hourly
    case dailyForecast
    case weatherInfo
}
