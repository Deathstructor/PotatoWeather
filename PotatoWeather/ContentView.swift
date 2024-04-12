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
    @StateObject var themeHandler = ThemeHandler()
    
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
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = themeHandler.currentTheme.TabBar
                appearance.stackedLayoutAppearance.normal.iconColor = themeHandler.currentTheme.UnselectedIcon
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: themeHandler.currentTheme.UnselectedIcon]
                        
                appearance.stackedLayoutAppearance.selected.iconColor = themeHandler.currentTheme.SelectedIcon
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: themeHandler.currentTheme.SelectedIcon]
                        
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
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
