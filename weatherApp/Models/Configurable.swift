//
//  Configurable.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 13/10/1447 AH.
//

protocol Configurable {
    associatedtype Model
    func configure(with model: Model)
}
