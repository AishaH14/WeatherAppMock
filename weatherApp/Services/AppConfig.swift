//
//  AppConfig.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 19/10/1447 AH.
//

import Foundation

enum AppConfig {
    static var apiKey: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("API_KEY not found in Info.plist")
        }
        return apiKey
    }
}
