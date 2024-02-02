//
//  LocationManager.swift
//  PotatoWeather
//
//  Created by Paul Chastain on 2024-01-19.
//

import Foundation
import SwiftUI
import MapKit

final class LocationManagerModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    //  The location manager
        var locationManager: CLLocationManager?
    
    //  Check if the user has authorized the use of location services.
    //  If not set, give prompt to ask for location.
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return };
            
        switch locationManager.authorizationStatus {
                
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            locationManager.stopUpdatingLocation();
            print("Location services are restricted on this device.")
        case .denied:
            locationManager.stopUpdatingLocation();
            print("Location services have been denied on this device. Go to settings to allow location services.")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation();
        @unknown default:
            break;
        }
    }
    
//  Checks if the location services are enabled on the device.
//  If they are enableled, create the location manager and set the delagate to locationManager.
    func checkLocationServices() {
            if CLLocationManager.locationServicesEnabled() {
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                locationManager?.startUpdatingLocation()
            } else {
                print("Location services have are disabled on this device.")
                return
            }
    }
    
//  If the location settings have changed, ask for permission again.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
