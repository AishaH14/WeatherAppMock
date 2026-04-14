//
//  WeatherService.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 21/09/1447 AH.
//
import Foundation

final class WeatherService {
    
     let apiKey = AppConfig.apiKey
     let requestBuilder = URLRequestBuilder()
    
    func fetchCurrentWeather(
        lat: Double,
        lon: Double,
        completion: @escaping (Result<WeatherResponse, Error>) -> Void
    ) {
        let apiRequest = WeatherEndpoint.currentWeather(lat: lat, lon: lon, apiKey: apiKey).request
        
        guard let request = requestBuilder.build(from: apiRequest) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        NetworkManager.shared.request(request: request, completion: completion)
    }
    
    func fetchForecast(
        lat: Double,
        lon: Double,
        completion: @escaping (Result<ForecastResponse, Error>) -> Void
    ) {
        let apiRequest = WeatherEndpoint.forecast(lat: lat, lon: lon, apiKey: apiKey).request
        
        guard let request = requestBuilder.build(from: apiRequest) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        NetworkManager.shared.request(request: request, completion: completion)
    }
}
