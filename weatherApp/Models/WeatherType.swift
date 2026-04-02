//
//  WeatherType.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 13/10/1447 AH.
//
import UIKit

enum WeatherType: String {
    
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
    case drizzle = "Drizzle"
    case thunderstorm = "Thunderstorm"
    case snow = "Snow"
    
    var text: String {
        switch self {
        case .clear:
            return "Sunny"
        case .clouds:
            return "Cloudy"
        case .rain, .drizzle:
            return "Rainy"
        case .thunderstorm:
            return "Storm"
        case .snow:
            return "Snow"
        }
    }
    
    var color: UIColor {
        switch self {
        case .clear:
            return .systemYellow
        case .clouds:
            return .white
        case .rain, .drizzle:
            return .white
        case .thunderstorm:
            return .white
        case .snow:
            return .white
        }
    }
    var icon: UIImage? {
        switch self {
        case .clear:
            return UIImage(systemName: "sun.max.fill")
        case .clouds:
            return UIImage(systemName: "cloud.fill")
        case .rain, .drizzle:
            return UIImage(systemName: "cloud.rain.fill")
        case .thunderstorm:
            return UIImage(systemName: "cloud.bolt.rain.fill")
        case .snow:
            return UIImage(systemName: "snow")
        }
    }
}
