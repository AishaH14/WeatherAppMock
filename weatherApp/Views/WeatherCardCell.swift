//
//  WeatherCardCell.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 26/09/1447 AH.
//

import UIKit

class WeatherCardCell: UICollectionViewCell {
    static let identifier = "WeatherCardCell"
 
    private enum Constants {
           static let sunriseTitle = "SUNRISE"
           static let imageTintAlpha: CGFloat = 0.7
           static let lineAlpha: CGFloat = 0.5
           static let cornerRadius: CGFloat = 22
           static let dayStartHour = 6
           static let dayEndHour = 18
       }
    
   
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var lineContainerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        imageLabel.tintColor = UIColor.white.withAlphaComponent(Constants.imageTintAlpha)
        imageLabel.contentMode = .scaleAspectFit
        imageLabel.backgroundColor = .clear
        cardView.layer.cornerRadius = 22
        cardView.clipsToBounds = true
        
        
        lineContainerView.backgroundColor = UIColor.white.withAlphaComponent(Constants.lineAlpha)
    }
    func configureGradient() {
            let hour = Calendar.current.component(.hour, from: Date())
            let isDay = hour >= Constants.dayStartHour && hour < Constants.dayEndHour
            cardView.applyWeatherGradient(isDay: isDay)
        }
        
        func updateSunriseUI() {
            let isSunrise = titleLabel.text == Constants.sunriseTitle
            lineContainerView.isHidden = !isSunrise
            
            if isSunrise {
                SunArcView.draw(on: cardView)
            } else {
                SunArcView.remove(from: cardView)
            }
        }
    func configure(with item: WeatherInfoCardItem) {
        titleLabel.text = item.title
        valueLabel.text = item.value
        bottomLabel.text = item.bottomText
        imageLabel.image = item.image
        imageLabel.tintColor = UIColor.white.withAlphaComponent(0.7)
        
        configureGradient()
        updateSunriseUI()
    }
        override func prepareForReuse() {
            super.prepareForReuse()
            lineContainerView.isHidden = true
            SunArcView.remove(from: cardView)
        }
    }

