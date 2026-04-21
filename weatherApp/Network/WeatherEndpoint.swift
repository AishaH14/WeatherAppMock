//
//  WeatherEndpoint.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 19/10/1447 AH.
import Foundation

enum Parameter: String {
    case query = "q"
    case lat = "lat"
    case lon = "lon"
    case limit = "limit"
}

enum WeatherEndpoint: EndpointContract {
    case geocoding(city: String)
    case currentWeather(lat: Double, lon: Double)
    case forecast(lat: Double, lon: Double)

    var path: String {
        switch self {
        case .geocoding:
            return "/geo/1.0/direct"
        case .currentWeather:
            return "/data/2.5/weather"
        case .forecast:
            return "/data/2.5/forecast"
        }
    }

    var items: [String: String] {
        switch self {
        case .geocoding(let city):
            return [
                Parameter.query.rawValue: city,
                Parameter.limit.rawValue: "1"
            ]

        case .currentWeather(let lat, let lon):
            return [
                Parameter.lat.rawValue: "\(lat)",
                Parameter.lon.rawValue: "\(lon)"
            ]

        case .forecast(let lat, let lon):
            return [
                Parameter.lat.rawValue: "\(lat)",
                Parameter.lon.rawValue: "\(lon)"
            ]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .geocoding, .currentWeather, .forecast:
            return .get
        }
    }

    var shouldIncludeMetricUnits: Bool {
        switch self {
        case .geocoding:
            return false
        case .currentWeather, .forecast:
            return true
        }
    }
}
