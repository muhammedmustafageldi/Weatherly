//
//  WeatherManager.swift
//  Weatherly
//
//  Created by Muhammed Mustafa Geldi on 9.03.2025.
//

import Foundation
import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?&appid=aa875368d635c3de7bec3673ae82067b&units=metric"
    
    func fetchWeather(city: String) {
        let urlString = "\(weatherUrl)&q=\(city)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    private func performRequest(with urlString: String) {
        // Create url ->
        if let url = URL(string: urlString) {
            // Create a URLSession ->
            let session = URLSession(configuration: .default)
            // Give the session a task ->
            let task = session.dataTask(with: url) { data, response, error in
                // Handle response
                if let safeError = error {
                    print("Failed to get data from url: \(safeError)")
                    delegate?.didFailWithError(error: safeError)
                    return
                }
                
                if let safeData = data {
                    // Parse json
                    if let safeWeather = self.parseJSON(safeData) {
                        delegate?.didUpdateWeather(self ,weather: safeWeather)
                    }
                }
            }
            // Start the task
            task.resume()
        }
    }
    
    private func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            // Parse data to model
            let name = decodedData.name
            let conditionId = decodedData.weather[0].id
            let main = decodedData.weather[0].main
            let description = decodedData.weather[0].description
            let temperature = decodedData.main.temp
            let feelsLike = decodedData.main.feels_like
            let tempMin = decodedData.main.temp_min
            let tempMax = decodedData.main.temp_max
            let humidity = decodedData.main.humidity
            let windSpeed = decodedData.wind.speed
            
            let weather = WeatherModel(name: name, conditionId: conditionId, main: main, description: description, temp: temperature, feelsLike: feelsLike, tempMin: tempMin, tempMax: tempMax, humidity: humidity, windSpeed: windSpeed)
            
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
