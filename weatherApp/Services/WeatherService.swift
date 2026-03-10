//
//  WeatherService.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 21/09/1447 AH.
//
import Foundation

class WeatherService {
    
    func fetchWeather(completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        
        let lat = 21.5433
        let lon = 39.1728
        let apiKey = "2de8e5316b9cf195e13078904b129e8c"
        
        let urlString =
        "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,hourly,daily,alerts&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code:", httpResponse.statusCode)
            }
            
            guard let data = data else { return }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON:", jsonString)
            }
           
            do {
                let decodedData = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }}
