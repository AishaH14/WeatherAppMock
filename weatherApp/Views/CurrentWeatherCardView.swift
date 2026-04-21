//
//  CurrentWeatherCardView.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 03/11/1447 AH.
//

import UIKit

final class CurrentWeatherCardView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        let nib = UINib(nibName: Constants.currentWeatherCardView, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)

        guard let contentView else { return }

        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    func configure(city: String, temp: String, condition: String) {
        cityLabel.text = city
        tempLabel.text = temp
        conditionLabel.text = condition
    }
}
