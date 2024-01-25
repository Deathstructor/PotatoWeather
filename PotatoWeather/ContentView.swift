//
//  PotatoWeatherApp.swift
//  PotatoWeather
//
//  Created by Paul Chastain on 2023-12-15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
//      Creates the navbar at the bottom of the screen and
//      displays each view based on the tab you're in.
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
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
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
        
    }
}

#Preview {
    ContentView()
}
