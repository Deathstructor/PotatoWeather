//
//  PotatoWeatherApp.swift
//  PotatoWeather
//
//  Created by Paul Chastain on 2023-12-15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        VStack {
//            Image(systemName: "cloud")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
        TabView {
            LocalWeatherView()
                .tabItem {
                    Image(systemName: "sun.max.fill")
                    Text("Weather")
                }
            ForecastView()
                .tabItem {
                    Image(systemName: "tornado")
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
        
    }
}

#Preview {
    ContentView()
}
