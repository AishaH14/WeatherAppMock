//
//  DailyForecastItem.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 26/10/1447 AH.
//
import Foundation

struct DailyForecastItem: Codable, Sendable {
    let day: String
    let minTemp: String
    let maxTemp: String
    let weatherType: WeatherType
}
