//
//  HourlySectionCell.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 21/09/1447 AH.
//

import UIKit

class HourlySectionCell: UITableViewCell {
    private var hourlyForecast: [ForecastItem] = []
    var onTapHourly: (() -> Void)?
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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            UINib(nibName: Constants.hourlyCell, bundle: nil),
            forCellWithReuseIdentifier:Constants.hourlyCell
                )

           if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
               layout.scrollDirection = .horizontal
           }
       
    }
    func configure(with items: [ForecastItem]) {
            hourlyForecast = items
            configureGradient()
            collectionView.reloadData()
        }
    func configureGradient() {
           let hour = Calendar.current.component(.hour, from: Date())
           let isDay = hour >= 6 && hour < 18
           containerView.applyWeatherGradient(isDay: isDay)
       }
    override func prepareForReuse() {
           super.prepareForReuse()
           hourlyForecast = []
       }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
extension HourlySectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyForecast.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.hourlyCell, for: indexPath) as? HourlyCell else {
            return UICollectionViewCell()
        }

        let item = hourlyForecast[indexPath.item]
        cell.configure(with: item)

        if indexPath.item == 0 {
            cell.timeLabel.text = "Now"
        }

        return cell
    }
}

extension HourlySectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 120)
    }
}
extension HourlySectionCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTapHourly?()
    }
}
