//
//  ViewController.swift
//  Weatherly
//
//  Created by Muhammed Mustafa Geldi on 3.03.2025.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var minimumLabel: UILabel!
    @IBOutlet weak var maximumLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    
    private var weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        let searchText = searchTextField.text ?? ""
        if(!searchText.isEmpty) {
            weatherManager.fetchWeather(city: searchText)
        }
        searchTextField.endEditing(true)
    }
    
    
    @IBAction func getWeatherWithUserLocation(_ sender: Any) {
        locationManager.requestLocation()
    }
}


// MARK: - UI TEXT FIELD DELEGATE

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ searchTextField: UITextField) -> Bool {
        print(searchTextField.text ?? "")
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else {
            textField.placeholder = "Enter city name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Fetch data
        if let city = textField.text {
            weatherManager.fetchWeather(city: city)
        }
        
        textField.text = ""
    }
}
  

// MARK: - WEATHER MANAGER DELEGATE

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        // Put data to layout on main thread
        DispatchQueue.main.async {
            self.putDataToLayout(from: weather)
        }
    }
    
    func putDataToLayout(from weather: WeatherModel) {
        cityLabel.text = weather.name
        temperatureLabel.text = String(weather.temperature)
        conditionImageView.image = UIImage(systemName: weather.conditionName)
        descriptionLabel.text = weather.main + ", " + weather.description
        feelsLikeLabel.text = "\(weather.feelsLike)°C"
        minimumLabel.text = "\(weather.tempMin)°C"
        maximumLabel.text = "\(weather.tempMax)°C"
        humidityLabel.text = "\(weather.humidity)%"
        windSpeedLabel.text = "\(weather.windSpeed)"
    }
    
    func didFailWithError(error: Error) {
        // To do cath the error
        print(error.localizedDescription)
    }
}


// MARK: - CLLLOCATION DELEGATE
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            // Fetch data with location info
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    
}

