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
}
