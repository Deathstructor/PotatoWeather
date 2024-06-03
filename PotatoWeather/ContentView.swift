//
//  PotatoWeatherApp.swift
//  PotatoWeather
//
//  Created by Paul Chastain on 2023-12-15.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var manager = LocationManagerModel()
    @StateObject var weather = FetchWeatherData()
    
    var body: some View {
        
        if manager.location != nil {
            LocalWeatherView()
        } else {
            if manager.isLoading {
                ProgressView()
            } else {
                Text("You need to share your location to be able to use this app.")
            }
        }
    }
}

#Preview {
    ContentView()
}
