//
//  HourlySectionCell.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 21/09/1447 AH.
//

import UIKit

class HourlySectionCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        WeatherTheme.applyGradient(to: containerView)

        collectionView.backgroundColor = .clear
        collectionView.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
