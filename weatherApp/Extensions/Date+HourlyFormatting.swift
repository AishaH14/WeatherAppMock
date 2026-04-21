//
//  Date+TimeFormatter.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 27/10/1447 AH.
//

import Foundation

extension Date {
    
    private static let hourlyTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()
    
    func formattedHourlyTime() -> String {
        Date.hourlyTimeFormatter.string(from: self)
    }
}
