//
//  WeatherInfoCell.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 26/09/1447 AH.
//

import UIKit

class WeatherInfoCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
   
        private let items: [WeatherInfoCardItem] = [
            WeatherInfoCardItem(
                title: "SUNRISE",
                value: "6:17 AM",
                bottomText: "Sunset: 5:56 PM",
                image: UIImage(systemName: "sunrise.fill")
            ),
            WeatherInfoCardItem(
                title: "PRECIPITATION",
                value: "0 mm",
                bottomText: "None expected in next 10 days.",
                image: UIImage(systemName: "drop.fill")
            ),
            WeatherInfoCardItem(
                title: "VISIBILITY",
                value: "22 km",
                bottomText: "Perfectly clear view.",
                image: UIImage(systemName: "eye.fill")
            ),
            WeatherInfoCardItem(
                title: "HUMIDITY",
                value: "72%",
                bottomText: "The dew point is 7° right now.",
                image: UIImage(systemName: "humidity.fill")
            )
        ]
        
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
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WeatherCardCell.identifier,
            for: indexPath
        ) as? WeatherCardCell else {
            return UICollectionViewCell()
        }

        let item = items[indexPath.item]
                cell.configure(with: item)
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
    
}
