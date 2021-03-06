//
//  NetworkManager.swift
//  CarManager
//
//  Created by Сергей Петров on 08.11.2021.
//

import Foundation

protocol NetworkManagerProtocol {
    func checkWeather()
}

class NetworkManager: NetworkManagerProtocol {

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
        _ = weatherData.daily.reduce(0.0) { $0 + $1.temp.day } / Double(weatherData.daily.count)
//        if weekMedianTemeperature < 7.0 {
//            carGateway.fetchCars { result in
//                switch result {
//                    case .success(let controller):
//                        if let cars = controller.fetchedObjects {
//                            let carsWithSummerTyres = cars.filter { car in
//                                if let tyreType = car.tireType {
//                                    return tyreType == CarInputData.TireTypes.summer.rawValue
//                                }
//                                return false
//                            }
//                            if carsWithSummerTyres.count > 0 {
//                                NotificationManager.shared.changeTiresNotification(carNickNames: carsWithSummerTyres,
//                                                                                   to: .winter, delay: 2)
//                            }
//                        }
//                    case .failure(let error):
//                        print("Fail to fetchCars!: \(error.localizedDescription)")
//                }
//            }
//        } else if weekMedianTemeperature > 10.0 {
//            carGateway.fetchCars { result in
//                switch result {
//                    case .success(let controller):
//                        if let cars = controller.fetchedObjects {
//                            let carsWithWinterTyres = cars.filter { car in
//                                if let tyreType = car.tireType {
//                                    return tyreType == CarInputData.TireTypes.winter.rawValue
//                                }
//                                return false
//                            }
//                            if carsWithWinterTyres.count > 0 {
//                                NotificationManager.shared.changeTiresNotification(carNickNames: carsWithWinterTyres,
//                                                                                   to: .summer, delay: 2)
//                            }
//                        }
//                    case .failure(let error):
//                        print("Fail to fetchCars!: \(error.localizedDescription)")
//                }
//            }
//        }
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
    let windSpeed: Double
    let windDeg: Int

    enum CodingKeys: String, CodingKey {
        case dt
        case temp
        case clouds
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
    }
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
    let senderName: String
    let event: String
    let start: Int
    let end: Int
    let description: String

    enum CodingKeys: String, CodingKey {
        case senderName = "sender_name"
        case event
        case start
        case end
        case description
    }
}
