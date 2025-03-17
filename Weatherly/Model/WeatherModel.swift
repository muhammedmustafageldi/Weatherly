//
//  WeatherModel.swift
//  Weatherly
//
//  Created by Muhammed Mustafa Geldi on 11.03.2025.
//

import Foundation

struct WeatherModel {
    
    let name: String
    let conditionId: Int
    let main: String
    let description: String
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Int
    let windSpeed: Double
    
    
    var temperature: Int {
        return Int(temp.rounded())
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 700...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "Weather icon not found."
        }
    }

}
