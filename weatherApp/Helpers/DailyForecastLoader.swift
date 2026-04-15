//
//  DailyForecastLoader.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 21/10/1447 AH.
//
import Foundation

final class DailyForecastLoader {
    
    static func load() async throws -> [DailyForecastItem] {
        try await LocalJSONLoader.load([DailyForecastItem].self, from: "DailyForecastData")
    }
}
