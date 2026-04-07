//
//  NetworkManager.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 13/10/1447 AH.
//
import Foundation

enum NetworkError: Error {
    case invalidResponse
    case httpError(statusCode: Int)
    case noData
    case invalidURL
}
final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<T: Decodable>(
        url: URL,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                            return
                        }
                        
                        guard httpResponse.statusCode == 200 else {
                            completion(.failure(NetworkError.httpError(statusCode: httpResponse.statusCode)))
                            return
                        }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
}
