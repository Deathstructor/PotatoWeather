//
//  MapView.swift
//  PotatoWeather
//
//  Created by Paul Chastain on 2024-01-25.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @State var viewModel = LocationManagerModel();
    
    var body: some View {
        Map(position: $viewModel.camPos){
            
        }
            .ignoresSafeArea()
            .onAppear {
                viewModel.checkLocationServices()
                print(viewModel.locationManager?.location?.coordinate ?? "no data")
            }
    }
}

#Preview {
    MapView()
}
