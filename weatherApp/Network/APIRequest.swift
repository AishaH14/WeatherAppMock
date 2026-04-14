//
//  APIRequest.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 25/10/1447 AH.
//
import Foundation

struct APIRequest {
    let path: String
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem] = []
}
