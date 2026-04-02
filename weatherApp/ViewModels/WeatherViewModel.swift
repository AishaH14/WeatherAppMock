//
//  WeatherViewModel.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 12/10/1447 AH.
//

import Foundation

class WeatherViewModel {
    
    private let service = WeatherService()
    
    var currentWeather: WeatherResponse?
    var forecast: ForecastResponse?
    
    func loadCurrentWeather(for city: String,
                            completion: @escaping (Result<Void, Error>) -> Void) {
        
        service.fetchCurrentWeather(for: city) { [weak self] result in
            switch result {
            case .success(let data):
                self?.currentWeather = data
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadForecast(for city: String,
                      completion: @escaping (Result<Void, Error>) -> Void) {
        
        service.fetchForecast(for: city) { [weak self] result in
            switch result {
            case .success(let data):
                self?.forecast = data
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
