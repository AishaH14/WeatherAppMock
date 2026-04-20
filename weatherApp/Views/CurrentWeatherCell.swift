//
//  CurrentWeatherCell.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 02/11/1447 AH.
//

import UIKit

class CurrentWeatherCell: UITableViewCell {
    
    @IBOutlet weak var weatherCardView: CurrentWeatherCardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    func configure(with weather: WeatherResponse) {
        weatherCardView.configure(with: weather)
    }
    
    func configure(city: String, temperature: String, description: String) {
        weatherCardView.configure(city: city, temperature: temperature, description: description)
    }
    
}
