//
//  LocalWeatherView.swift
//  PotatoWeather
//
//  Created by Paul Chastain on 2024-01-14.
//

import SwiftUI
import CoreLocation

struct LocalWeatherView: View {
    
    //    @StateObject var fetchWeatherModel = FetchWeatherData()
    @StateObject var manager = LocationManagerModel()
    @StateObject var fetchWeather = FetchWeatherData()
    
    @State var weather: WeatherData?
    
//    @State var lon: CLLocationDegrees = coorManager.lon
//    @State var lat: CLLocationDegrees = coorManager.lat
    
    var body: some View {
        VStack(spacing: 30) {
            if let location = manager.location {
                if let weather = weather {
                    VStack {
                        Text("\(String(describing: weather.timeSeries[0].parameters[0].values[0])) °C")
                            .bold()
                            .font(.largeTitle)
                    }
                } else {
                    ProgressView()
                        .task {
                            do {
                                weather = try await fetchWeather.getWeatherData(
                                    lon: location.longitude,
                                    lat: location.latitude
                                )
                            } catch {
                                print("Error getting weather data: ", error)
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    LocalWeatherView()
}
