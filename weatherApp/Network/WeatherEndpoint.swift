//
//  WeatherEndpoint.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 19/10/1447 AH.
import Foundation

enum WeatherEndpoint {
    case geocoding(city: String, apiKey: String)
    case currentWeather(lat: Double, lon: Double, apiKey: String)
    case forecast(lat: Double, lon: Double, apiKey: String)

    var request: APIRequest {
        switch self {
        case .geocoding(let city, let apiKey):
            return APIRequest(
                path: "/geo/1.0/direct",
                queryItems: [
                    URLQueryItem(name: "q", value: city),
                    URLQueryItem(name: "limit", value: "1"),
                    URLQueryItem(name: "appid", value: apiKey)
                ]
            )

        case .currentWeather(let lat, let lon, let apiKey):
            return APIRequest(
                path: "/data/2.5/weather",
                queryItems: [
                    URLQueryItem(name: "lat", value: "\(lat)"),
                    URLQueryItem(name: "lon", value: "\(lon)"),
                    URLQueryItem(name: "appid", value: apiKey),
                    URLQueryItem(name: "units", value: "metric")
                ]
            )

        case .forecast(let lat, let lon, let apiKey):
            return APIRequest(
                path: "/data/2.5/forecast",
                queryItems: [
                    URLQueryItem(name: "lat", value: "\(lat)"),
                    URLQueryItem(name: "lon", value: "\(lon)"),
                    URLQueryItem(name: "appid", value: apiKey),
                    URLQueryItem(name: "units", value: "metric")
                ]
            )
        }
    }
}
