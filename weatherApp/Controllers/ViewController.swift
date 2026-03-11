//
//  ViewController.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 15/09/1447 AH.
//
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyCell
        
        cell.timeLabel.text = "3PM"
        cell.tempLabel.text = "32°"
        cell.weatherImage.image = UIImage(systemName: "sun.max.fill")
        
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var weatherBackgroundImageView: UIImageView!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBAction func searchTapped(_ sender: Any) {
            print("Search tapped")
    }
    let weatherService = WeatherService()
    var weatherData: WeatherResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
       // updateBackground()
        
        weatherBackgroundImageView.image = UIImage(named: "dd")
        weatherBackgroundImageView.contentMode = .scaleToFill
        weatherBackgroundImageView.backgroundColor = .red
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        
        
        tableView.register(UINib(nibName: "CurrentWeatherCell", bundle: nil),
                           forCellReuseIdentifier: "CurrentWeatherCell")
        
        tableView.register(UINib(nibName: "HourlySectionCell", bundle: nil),
                           forCellReuseIdentifier: "HourlySectionCell")
        
     
        fetchWeather()
        tableView.backgroundColor = .clear
        searchButton.showsTouchWhenHighlighted = true

    }
    func fetchWeather() {
        weatherService.fetchWeather { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.weatherData = data
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print("Error fetching weather:", error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentWeatherCell", for: indexPath) as! CurrentWeatherCell
            
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            
            if let weather = weatherData {
                cell.cityLabel.text = "Jeddah"
                cell.tempLabel.text = "\(Int(weather.current.temp))°"
                cell.weatherLabel.text = weather.current.weather.first?.main ?? "No Data"
                cell.weatherImage.image = UIImage(systemName: "sun.max.fill")
                cell.weatherImage.tintColor = .white
            } else {
                cell.cityLabel.text = "Loading..."
                cell.tempLabel.text = "--"
                cell.weatherLabel.text = "Please wait"
                cell.weatherImage.image = nil
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlySectionCell", for: indexPath) as! HourlySectionCell

            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.register(UINib(nibName: "HourlyCell", bundle: nil),
                                         forCellWithReuseIdentifier: "HourlyCell")
            cell.collectionView.reloadData()

            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 220
        } else {
            return 160
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 120)
    }
    func updateBackground() {
        let hour = Calendar.current.component(.hour, from: Date())

        if hour >= 6 && hour < 18 {
            view.backgroundColor = UIColor(patternImage: UIImage(named: "dd")!)
        } else {
            view.backgroundColor = UIColor(patternImage: UIImage(named: "galaxy-background")!)
        }
    
    }
}
