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
            // Creates the navbar at the bottom of the screen and
            // displays each view based on the tab you're in.
            TabView {
                LocalWeatherView()
                    .tabItem {
                        Image(systemName: "sun.max.fill")
                        Text("Weather")
                    }
                ForecastView()
                    .tabItem {
                        Image(systemName: "calendar.badge.clock")
                        Text("Forecast")
                    }
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
            .background {
                Color.white
            }
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
