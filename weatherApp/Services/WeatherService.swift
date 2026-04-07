//
//  WeatherService.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 21/09/1447 AH.
//
import Foundation

final class WeatherService {
    
    private let apiKey = "2de8e5316b9cf195e13078904b129e8c"
    
    func fetchCurrentWeather(for city: String,
                             completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        
        guard let url = WeatherEndpoint.currentWeather(city: city, apiKey: apiKey).url else {
                   print("Invalid current weather URL")
                   return
               }
        

        NetworkManager.shared.request(url: url, completion: completion)
    }
    
    func fetchForecast(for city: String,
                       completion: @escaping (Result<ForecastResponse, Error>) -> Void) {
        
        guard let url = WeatherEndpoint.forecast(city: city, apiKey: apiKey).url else {
                    print("Invalid forecast URL")
                    return
                }
        NetworkManager.shared.request(url: url, completion: completion)
    }
}
