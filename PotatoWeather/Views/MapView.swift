//
//  MapView.swift
//  PotatoWeather
//
//  Created by Paul Chastain on 2024-01-25.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject var viewModel = LocationManagerModel()
    
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
    
    var body: some View {
        Map(position: $camPos)
            .onAppear {
                viewModel.checkLocationServices()
                print(viewModel.locationManager?.location?.coordinate ?? "no data")
            }
    }
}

#Preview {
    MapView()
}
