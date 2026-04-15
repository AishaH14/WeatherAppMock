//
//  Date+Formatters.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 27/10/1447 AH.
//
import Foundation

extension Date {
    
    private static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()
    
    private static let selectedDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        return formatter
    }()
    
    func formattedFullDate() -> String {
        Date.fullDateFormatter.string(from: self)
    }
    
    func formattedSelectedDate() -> String {
        Date.selectedDateFormatter.string(from: self)
    }
}
