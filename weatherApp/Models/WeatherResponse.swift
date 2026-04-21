//
//  WeatherResponse.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 21/09/1447 AH

import Foundation

// MARK: - Current Weather
struct WeatherResponse: Codable {
    let name: String
    let main: MainWeather
    let weather: [WeatherCondition]
}

struct MainWeather: Codable {
    let temp: Double
}

// MARK: - Forecast
struct ForecastResponse: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable {
    let dt: Int
    let main: MainWeather
    let weather: [WeatherCondition]
}

// MARK: - Common
struct WeatherCondition: Codable {
    let main: String
    let description: String
    let icon: String?
}
