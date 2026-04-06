//
//  WeatherTheme.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 26/09/1447 AH.
//

import UIKit

class WeatherTheme {

    static func colors(isDay: Bool) -> [CGColor] {
        if isDay {
            return [
                UIColor(red: 0.18, green: 0.47, blue: 0.82, alpha: 1).cgColor,
                UIColor(red: 0.32, green: 0.62, blue: 0.90, alpha: 1).cgColor,
                UIColor(red: 0.55, green: 0.78, blue: 0.96, alpha: 1).cgColor
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
