//
//  WeatherGradientProvider.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 26/09/1447 AH.
//

import UIKit

enum WeatherGradientProvider {
    static func colors(isDay: Bool) -> [CGColor] {
        if isDay {
            return [
                UIColor(red: 0.23, green: 0.53, blue: 0.95, alpha: 1).cgColor,
                UIColor(red: 0.45, green: 0.76, blue: 0.98, alpha: 1).cgColor,
                UIColor(red: 0.70, green: 0.88, blue: 0.99, alpha: 1).cgColor
            ]
        } else {
            return [
                UIColor(red: 0.05, green: 0.09, blue: 0.24, alpha: 1).cgColor,
                UIColor(red: 0.11, green: 0.18, blue: 0.40, alpha: 1).cgColor,
                UIColor(red: 0.26, green: 0.33, blue: 0.57, alpha: 1).cgColor
            ]
        }
    }
    
}
