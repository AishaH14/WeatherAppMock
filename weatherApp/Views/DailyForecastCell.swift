//
//  DailyForecastCell2.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 26/09/1447 AH.
//

import UIKit

class DailyForecastCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate  {
    struct Forecast {
           let day: String
           let minTemp: String
           let maxTemp: String
           let weatherType: WeatherType
       }

       let forecastData: [Forecast] = [
        Forecast(day: "Today", minTemp: "24°", maxTemp: "33°",weatherType :.clear),
        Forecast(day: "Fri", minTemp: "22°", maxTemp: "31°", weatherType:.clear),
        Forecast(day: "Sat", minTemp: "23°", maxTemp: "32°", weatherType:.clouds),
        Forecast(day: "Sun", minTemp: "25°", maxTemp: "34°", weatherType:.drizzle),
        Forecast(day: "Mon", minTemp: "21°", maxTemp: "30°", weatherType:.rain),
        Forecast(day: "Tue", minTemp: "22°", maxTemp: "29°", weatherType:.drizzle),
        Forecast(day: "Wed", minTemp: "24°", maxTemp: "33°", weatherType:.clear),
        Forecast(day: "Thu", minTemp: "23°", maxTemp: "32°", weatherType:.thunderstorm),
        Forecast(day: "Fri", minTemp: "22°", maxTemp: "31°", weatherType:.clear),
        Forecast(day: "Sat", minTemp: "18°", maxTemp: "30°", weatherType:.clouds)
           ]
       
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var dailyTableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dailyTableView.dataSource = self
        dailyTableView.delegate = self

        dailyTableView.register(UINib(nibName: "DailyRowCell", bundle: nil),
                                forCellReuseIdentifier: "DailyRowCell")

        dailyTableView.backgroundColor = .clear
        dailyTableView.backgroundView = UIView()
        dailyTableView.backgroundView?.backgroundColor = .clear
        dailyTableView.separatorStyle = .singleLine
        dailyTableView.separatorColor = UIColor.white.withAlphaComponent(0.3)
        dailyTableView.rowHeight = 44
        dailyTableView.isScrollEnabled = false
        dailyTableView.tableFooterView = UIView()
        dailyTableView.tableFooterView?.backgroundColor = .clear

        dailyTableView.reloadData()
        dailyTableView.isUserInteractionEnabled = false
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("daily row =", indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyRowCell", for: indexPath) as! DailyRowCell
        let item = forecastData[indexPath.row]

        cell.dayLabel.text = item.day
        cell.tempMinLabel.text = item.minTemp
        cell.tempMaxLabel.text = item.maxTemp
        cell.weatherImage.image = item.weatherType.icon
        cell.weatherImage.tintColor = item.weatherType.color
        return cell
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let hour = Calendar.current.component(.hour, from: Date())
        let isDay = hour >= 6 && hour < 18
        cardView.applyWeatherGradient(colors: WeatherTheme.colors(isDay: isDay))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
