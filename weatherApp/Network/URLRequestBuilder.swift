//
//  URLRequestBuilder.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 25/10/1447 AH.
//
import Foundation

struct URLRequestBuilder {
    
    private let baseURL = "https://api.openweathermap.org"
    
    func build(from apiRequest: APIRequest) -> URLRequest? {
        var components = URLComponents(string: baseURL)
        components?.path = apiRequest.path
        components?.queryItems = apiRequest.queryItems.isEmpty ? nil : apiRequest.queryItems
        
        guard let url = components?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = apiRequest.method.rawValue
        return request
    }
}
