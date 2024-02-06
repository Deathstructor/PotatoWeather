//
//  LocationManager.swift
//  PotatoWeather
//
//  Created by Paul Chastain on 2024-01-19.
//

import Foundation
import SwiftUI
import CoreLocation

final class LocationManagerModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        requestPermission()
    }
    
    func requestPermission() {
        isLoading = true
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization();
            print("not determined")
            
        case .restricted:
            locationManager.stopUpdatingLocation();
            print("restricted")
            
        case .denied:
            locationManager.stopUpdatingLocation();
            print("denied")
            
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            print("authorized")
            locationManager.startUpdatingLocation();
            
        default:
            break;
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        isLoading = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: ", error)
        isLoading = false
    }
    
    
}
