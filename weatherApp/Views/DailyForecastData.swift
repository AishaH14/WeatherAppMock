//
//  DailyForecastData.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 21/10/1447 AH.
//
import Foundation

enum DailyForecastData {
    static let items: [DailyForecastItem] = [
        .init(day: "Today", minTemp: "24°", maxTemp: "33°", weatherType: .clear),
        .init(day: "Fri", minTemp: "22°", maxTemp: "31°", weatherType: .clear),
        .init(day: "Sat", minTemp: "23°", maxTemp: "32°", weatherType: .clouds),
        .init(day: "Sun", minTemp: "25°", maxTemp: "34°", weatherType: .drizzle),
        .init(day: "Mon", minTemp: "21°", maxTemp: "30°", weatherType: .rain),
        .init(day: "Tue", minTemp: "22°", maxTemp: "29°", weatherType: .drizzle),
        .init(day: "Wed", minTemp: "24°", maxTemp: "33°", weatherType: .clear),
        .init(day: "Thu", minTemp: "23°", maxTemp: "32°", weatherType: .thunderstorm),
        .init(day: "Fri", minTemp: "22°", maxTemp: "31°", weatherType: .clear),
        .init(day: "Sat", minTemp: "18°", maxTemp: "30°", weatherType: .clouds)
    ]
}
struct DailyForecastItem {
    let day: String
    let minTemp: String
    let maxTemp: String
    let weatherType: WeatherType
}
