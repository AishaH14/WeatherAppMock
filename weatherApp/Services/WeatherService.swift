//
//  WeatherService.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 21/09/1447 AH.
//
import Foundation

final class WeatherService {
    
    private let apiKey = AppConfig.apiKey
    
    func fetchCurrentWeather(for city: String,
                             completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        
        guard let url = WeatherEndpoint.currentWeather(city: city, apiKey: apiKey).url else {
            completion(.failure(NetworkError.invalidURL))
                   return
               }
        

        NetworkManager.shared.request(url: url, completion: completion)
    }
    
    func fetchForecast(for city: String,
                       completion: @escaping (Result<ForecastResponse, Error>) -> Void) {
        
        guard let url = WeatherEndpoint.forecast(city: city, apiKey: apiKey).url else {
            completion(.failure(NetworkError.invalidURL))
                    return
                }
        NetworkManager.shared.request(url: url, completion: completion)
    }
}
