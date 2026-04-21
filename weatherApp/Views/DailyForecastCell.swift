//
//  DailyForecastCell2.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 26/09/1447 AH.
//

import UIKit

class DailyForecastCell: UITableViewCell {
    
    private var forecastData: [DailyForecastItem] = []
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var dailyTableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 20
        cardView.layer.masksToBounds = true
        dailyTableView.dataSource = self
        
        dailyTableView.register(UINib(nibName: Constants.dailyRowCell, bundle: nil),
                                forCellReuseIdentifier: Constants.dailyRowCell)
        
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
    func configure(with items: [DailyForecastItem]) {
            forecastData = items
            configureGradient()
            dailyTableView.reloadData()
        }
    func configureGradient() {
        let hour = Calendar.current.component(.hour, from: Date())
        let isDay = hour >= 6 && hour < 18
        cardView.applyWeatherGradient(isDay: isDay)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
    extension DailyForecastCell: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return forecastData.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            print("daily row =", indexPath.row)
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.dailyRowCell,
                for: indexPath
            ) as? DailyRowCell else {
                return UITableViewCell()
            }
            let item = forecastData[indexPath.row]
            
            cell.dayLabel.text = item.day
            cell.tempMinLabel.text = item.minTemp
            cell.tempMaxLabel.text = item.maxTemp
            cell.weatherImage.image = item.weatherType.icon
            cell.weatherImage.tintColor = item.weatherType.color
            return cell
        }
    
    }
