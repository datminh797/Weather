//
//  WeatherData.swift
//  Weather
//
//  Created by minhdat on 12/10/2022.
//

import Foundation
struct WeatherData : Codable {
    let name : String
    let main : Main
    let weather : [Weather]
}

struct Main : Codable {
    let temp : Double
    let humidity : Double
}

struct Weather : Codable {
    let id : Int
    let description : String
}

