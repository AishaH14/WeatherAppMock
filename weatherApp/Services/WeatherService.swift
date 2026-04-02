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
        
        let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityEncoded)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            print("Invalid current weather URL")
            return
        }
        
      
        NetworkManager.shared.request(url: url, completion: completion)
    }
    
    func fetchForecast(for city: String,
                       completion: @escaping (Result<ForecastResponse, Error>) -> Void) {
        
        let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityEncoded)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            print("Invalid forecast URL")
            return
        }
        
        
        NetworkManager.shared.request(url: url, completion: completion)
    }
}
