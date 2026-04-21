//
//  GeocodingResponse.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 25/10/1447 AH.
//

import Foundation

struct GeocodingResponse: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String?
    let state: String?
}
