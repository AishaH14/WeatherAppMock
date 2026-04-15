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
    
    private func loadWeatherData(
        for city: String,
        action: @escaping (_ lat: Double, _ lon: Double) -> Void,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        service.fetchCoordinates(for: city) { result in
            switch result {
            case .success(let location):
                action(location.lat, location.lon)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadCurrentWeather(
        for city: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        loadWeatherData(for: city, action: { [weak self] lat, lon in
            self?.loadCurrentWeather(lat: lat, lon: lon, completion: completion)
        }, completion: completion)
    }
    
    func loadForecast(
        for city: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        loadWeatherData(for: city, action: { [weak self] lat, lon in
            self?.loadForecast(lat: lat, lon: lon, completion: completion)
        }, completion: completion)
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
