//
//  WeatherViewModel.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 12/10/1447 AH.
//

import Foundation

final class WeatherViewModel {
    
    private let service = WeatherService()
    
    var currentWeather: WeatherResponse?
    var forecast: ForecastResponse?
    
    func loadCurrentWeather(
        for city: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        service.fetchCoordinates(for: city) { [weak self] result in
            switch result {
            case .success(let location):
                self?.service.fetchCurrentWeather(
                    lat: location.lat,
                    lon: location.lon
                ) { result in
                    switch result {
                    case .success(let data):
                        self?.currentWeather = data
                        completion(.success(()))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadForecast(
        for city: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        service.fetchCoordinates(for: city) { [weak self] result in
            switch result {
            case .success(let location):
                self?.service.fetchForecast(
                    lat: location.lat,
                    lon: location.lon
                ) { result in
                    switch result {
                    case .success(let data):
                        self?.forecast = data
                        completion(.success(()))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadCurrentWeather(
        lat: Double,
        lon: Double,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        service.fetchCurrentWeather(lat: lat, lon: lon) { [weak self] result in
            switch result {
            case .success(let data):
                self?.currentWeather = data
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadForecast(
        lat: Double,
        lon: Double,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        service.fetchForecast(lat: lat, lon: lon) { [weak self] result in
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
