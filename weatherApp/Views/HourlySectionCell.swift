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
        collectionView.backgroundColor = .clear
        collectionView.isUserInteractionEnabled = true
        collectionView.isScrollEnabled = true
           collectionView.alwaysBounceHorizontal = true
           collectionView.showsHorizontalScrollIndicator = false

           if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
               layout.scrollDirection = .horizontal
           }
       
    }
    func configureGradient() {
           let hour = Calendar.current.component(.hour, from: Date())
           let isDay = hour >= 6 && hour < 18
           containerView.applyWeatherGradient(isDay: isDay)
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
