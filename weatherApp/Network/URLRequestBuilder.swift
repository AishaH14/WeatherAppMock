//
//  URLRequestBuilder.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 25/10/1447 AH.
//
import Foundation

struct URLRequestBuilder {
    private let baseURL = "https://api.openweathermap.org"
    private let apiKey: String
    init(apiKey: String) {
            self.apiKey = apiKey
        }
    func build(from apiRequest: EndpointContract) -> URLRequest? {
        var components = URLComponents(string: baseURL)
        components?.path = apiRequest.path
        var queryparameters = apiRequest.items
        queryparameters["appid"] = apiKey
                if apiRequest.shouldIncludeMetricUnits {
                    queryparameters["units"] = "metric"
                }
        components?.queryItems = queryparameters.map{URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = components?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = apiRequest.method.rawValue
        return request
    }
}
