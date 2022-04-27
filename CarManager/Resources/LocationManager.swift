//
//  LocationManager.swift
//  CarManager
//
//  Created by Сергей Петров on 09.11.2021.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol: CLLocationManagerDelegate {
    func requestAccess()
    func getCurrentLocation() -> (latitude: String, longitude: String)?
}

class LocationManager: NSObject, LocationManagerProtocol {
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private var latitude: String? = ""
    private var longitude: String? = ""
    
    public func requestAccess() {
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    public func getCurrentLocation() -> (latitude: String, longitude: String)? {
        guard let latitude = latitude, let longitude = longitude else {
            return nil
        }
        if latitude != "" && longitude != "" {
            return (latitude: latitude, longitude: longitude)
        }
        return nil
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.latitude = String(locationValue.latitude)
        self.longitude = String(locationValue.longitude)
    }
}
