//
//  WeatherResponse.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 21/09/1447 AH

import Foundation

struct WeatherResponse: Codable, Sendable {
    let current: CurrentWeather
}

struct CurrentWeather: Codable, Sendable {
    let temp: Double
    let weather: [WeatherCondition]
}

struct WeatherCondition: Codable, Sendable {
    let main: String
    let description: String
}
