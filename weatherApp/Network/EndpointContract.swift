//
//  EndpointContract.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 25/10/1447 AH.
//
import Foundation
protocol EndpointContract {
    var path: String { get }
    var items: [String: String] { get }
    var method: HTTPMethod { get }
    var shouldIncludeMetricUnits: Bool { get }
}
