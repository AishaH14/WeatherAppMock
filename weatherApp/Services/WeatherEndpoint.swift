//
//  WeatherEndpoint.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 19/10/1447 AH.
//

import Foundation

enum WeatherEndpoint {
    case currentWeather(city: String, apiKey: String)
    case forecast(city: String, apiKey: String)

    private var baseURL: String {
        "https://api.openweathermap.org"
    }

    private var path: String {
        switch self {
        case .currentWeather:
            return "/data/2.5/weather"
        case .forecast:
            return "/data/2.5/forecast"
        }
    }

    private var queryItems: [URLQueryItem] {
        switch self {
        case .currentWeather(let city, let apiKey),
             .forecast(let city, let apiKey):
            return [
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "metric")
            ]
        }
    }

    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path = path
        components?.queryItems = queryItems
        return components?.url
    }
}
