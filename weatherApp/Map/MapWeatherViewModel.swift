//
//  MapWeatherViewModel.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 04/11/1447 AH.
//

import Foundation

final class MapWeatherViewModel {
    
    private let service = WeatherService()
    
    var currentWeather: WeatherResponse?
    
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
}
