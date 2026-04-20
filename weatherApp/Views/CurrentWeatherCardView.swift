//
//  CurrentWeatherCardView.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 03/11/1447 AH.
//

import UIKit

final class CurrentWeatherCardView: UIView {

//    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
//        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        commonInit()
    }

//    private func commonInit() {
//        addSubview(contentView)
//        contentView.frame = bounds
//        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        backgroundColor = .clear
//        contentView.backgroundColor = .clear
//    }

    func configure(with weather: WeatherResponse) {
        cityLabel.text = weather.name
        temperatureLabel.text = "\(Int(weather.main.temp))°"
        descriptionLabel.text = weather.weather.first?.description.capitalized ?? "Clear"
    }

    func configure(city: String, temperature: String, description: String) {
        cityLabel.text = city
        temperatureLabel.text = temperature
        descriptionLabel.text = description
    }
}
