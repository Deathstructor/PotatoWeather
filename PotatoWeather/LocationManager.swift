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
    
//  Gets the camera position for the map
    @State var camPos: MapCameraPosition = .region(MKCoordinateRegion(
            center: CLLocationCoordinate2DMake(
                59.1852,
                17.6207
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.05,
                longitudeDelta: 0.05
            )
    ));
    
//  Checks if the location services are enabled on the device.
//  If they are enableled, create the location manager and set the delagate to locationManager.
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        } else {
            print("Location services have are disabled on this device.")
            //Alert(title: Text("Location services"),
            //      message: Text("Location services have been turned off on this device."),
            //      dismissButton: .default(Text("Ok"))
            //)
        }
    }
    
//  Check if the user has authorized the use of location services.
//  If not set, give prompt to ask for location.
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return };
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location services are restricted on this device.")
        case .denied:
            print("Location services have been denied on this device. Go to settings to allow location services.")
        case .authorizedAlways, .authorizedWhenInUse:
            camPos = .region(MKCoordinateRegion(
                center: locationManager.location!.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.05,
                    longitudeDelta: 0.05
                )
        ));
        @unknown default:
            break;
        }
    }
    
//  If the location settings have changed, ask for permission again.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
