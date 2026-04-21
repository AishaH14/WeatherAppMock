//
//  WeatherGradient.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 17/10/1447 AH.
//

import UIKit

extension UIView {
    func applyWeatherGradient(colors: [CGColor]) {
        layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)

        layer.insertSublayer(gradient, at: 0)
    }
    func applyWeatherGradient(isDay: Bool) {
            let colors = isDay
            ? [
                UIColor(red: 0.18, green: 0.47, blue: 0.82, alpha: 1).cgColor,
                UIColor(red: 0.32, green: 0.62, blue: 0.90, alpha: 1).cgColor,
                UIColor(red: 0.55, green: 0.78, blue: 0.96, alpha: 1).cgColor
            ]
            : [
                UIColor(red: 0.05, green: 0.09, blue: 0.24, alpha: 1).cgColor,
                UIColor(red: 0.11, green: 0.18, blue: 0.40, alpha: 1).cgColor,
                UIColor(red: 0.18, green: 0.27, blue: 0.50, alpha: 1).cgColor
            ]

            applyWeatherGradient(colors: colors)
        }
    }

