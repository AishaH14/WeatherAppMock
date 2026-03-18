//
//  HourlyCell.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 19/09/1447 AH.
//

import UIKit

class HourlyCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
           
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = .clear

        timeLabel.textColor = .white.withAlphaComponent(0.7)
        tempLabel.textColor = .white
        weatherImage.tintColor = .white
        weatherImage.backgroundColor = .clear
    }

        
    }
