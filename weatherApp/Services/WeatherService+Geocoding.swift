//
//  WeatherService+Geocoding.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 25/10/1447 AH.
//

import Foundation

extension WeatherService {
    
    func fetchCoordinates(
        for city: String,
        completion: @escaping (Result<GeocodingResponse, Error>) -> Void
    ) {
        let apiRequest = WeatherEndpoint.geocoding(city: city)
        
        guard let request = requestBuilder.build(from: apiRequest) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        NetworkManager.shared.request(request: request) { (result: Result<[GeocodingResponse], Error>) in
            switch result {
            case .success(let locations):
                guard let firstLocation = locations.first else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                completion(.success(firstLocation))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
