//
//  WeatherInfoCell.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 26/09/1447 AH.
//

import UIKit

class WeatherInfoCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isUserInteractionEnabled = false
        collectionView.register(UINib(nibName: WeatherCardCell.identifier, bundle: nil), forCellWithReuseIdentifier: WeatherCardCell.identifier)
        
    }
}

extension WeatherInfoCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WeatherCardCell.identifier,
            for: indexPath
        ) as? WeatherCardCell else {
            return UICollectionViewCell()
        }

        switch indexPath.item {
        case 0:
            cell.titleLabel.text = "SUNRISE"
            cell.valueLabel.text = "6:17 AM"
            cell.bottomLabel.text = "Sunset: 5:56 PM"
            cell.imageLabel.image = UIImage(systemName: "sunrise.fill")

        case 1:
            cell.titleLabel.text = "PRECIPITATION"
            cell.valueLabel.text = "0 mm"
            cell.bottomLabel.text = "None expected in next 10 days."
            cell.imageLabel.image = UIImage(systemName: "drop.fill")

        case 2:
            cell.titleLabel.text = "VISIBILITY"
            cell.valueLabel.text = "22 km"
            cell.bottomLabel.text = "Perfectly clear view."
            cell.imageLabel.image = UIImage(systemName: "eye.fill")

        default:
            cell.titleLabel.text = "HUMIDITY"
            cell.valueLabel.text = "72%"
            cell.bottomLabel.text = "The dew point is 7° right now."
            cell.imageLabel.image = UIImage(systemName: "humidity.fill")
        }

        cell.imageLabel.tintColor = UIColor.white.withAlphaComponent(0.7)
        return cell
    }
}
extension WeatherInfoCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 12 + 12 + 12
        let width = (collectionView.frame.width - totalSpacing) / 2
        return CGSize(width: width, height: 160)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }
    
}
