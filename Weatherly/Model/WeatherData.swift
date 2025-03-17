//
//  WeatherData.swift
//  Weatherly
//
//  Created by Muhammed Mustafa Geldi on 9.03.2025.
//

import Foundation


struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Int
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
}

struct Wind: Codable {
    let speed: Double
}

