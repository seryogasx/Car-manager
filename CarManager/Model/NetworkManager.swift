//
//  NetworkManager.swift
//  CarManager
//
//  Created by Сергей Петров on 08.11.2021.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let scheme = "https"
    private let host = "api.openweathermap.org"
    private let path = "/data/2.5/onecall"
    
    private init() {  }
    
    public func checkWeather() {
        
//        guard let location = LocationManager.shared.getCurrentLocation() else { return }
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        
        let lat = URLQueryItem(name: "lat", value: "55.558741")
        let lon = URLQueryItem(name: "lon", value: "37.378847")
//        let lat = URLQueryItem(name: "lat", value: location.latitude)
//        let lon = URLQueryItem(name: "lon", value: location.longitude)
        let exclude = URLQueryItem(name: "exclude", value: "minutely,hourly")
        let units = URLQueryItem(name: "units", value: "metric")
        let token = URLQueryItem(name: "appid", value: AppConfig.weatherToken)
        components.queryItems = [lat, lon, exclude, units, token]

        guard let queryURL = components.url else {
            print("NetworkManager error: wrong url!")
            return
        }
        print(queryURL)
        URLSession.shared.dataTask(with: queryURL) { [weak self] data, response, error in
            if let error = error {
                print("NetworkManager error: \(error.localizedDescription)")
            } else if (response as? HTTPURLResponse)?.statusCode == 200, let data = data {
                if let queryResult = try? JSONDecoder().decode(WeatherData.self, from: data) {
                  self?.checkWeatherData(queryResult)
                }
            }
        }.resume()
    }
    
    private func checkWeatherData(_ weatherData: WeatherData) {
        let weekMedianTemeperature = weatherData.daily.reduce(0.0) { $0 + $1.temp.day } / Double(weatherData.daily.count)
        if weekMedianTemeperature < 7.0 {
            let cars = StorageManager.shared.carsWithTires(tiresType: .summer)
            if cars.count > 0 {
                NotificationManager.shared.changeTiresNotification(carNickNames: cars, to: .winter, delay: 2)
            }
        } else if weekMedianTemeperature > 10.0 {
            let cars = StorageManager.shared.carsWithTires(tiresType: .winter)
            if cars.count > 0 {
                NotificationManager.shared.changeTiresNotification(carNickNames: cars, to: .summer, delay: 2)
            }
        }
    }
}

struct WeatherData: Codable {
    let daily: [WeatherInfo]
    let alerts: [WeatherAlert]
}

struct WeatherInfo: Codable {
    let dt: Int
    let temp: Temperature
    let clouds: Int
    let wind_speed: Double
    let wind_deg: Int
}

struct Temperature: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
}

struct WeatherAlert: Codable {
    let sender_name: String
    let event: String
    let start: Int
    let end: Int
    let description: String
}

