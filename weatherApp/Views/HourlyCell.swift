//
//  HourlyCell.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 19/09/1447 AH.
//

import UIKit

class HourlyCell: UICollectionViewCell, Configurable {
    typealias Model = ForecastItem
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = .clear

        timeLabel.textColor = .white.withAlphaComponent(0.7)
        tempLabel.textColor = .white
        weatherImage.tintColor = .white
        weatherImage.backgroundColor = .clear
    }
    func configure(with item: ForecastItem) {
        
        
        let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
        timeLabel.text = date.formattedHourlyTime()
        tempLabel.text = "\(Int(item.main.temp))°"
        let condition = item.weather.first?.main.lowercased() ?? "clear"
        let type = WeatherType(rawValue: condition) ?? .clouds
        weatherImage.image = type.icon
        weatherImage.tintColor = .white
    }
        
    }
