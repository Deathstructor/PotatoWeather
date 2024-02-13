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
    @StateObject var weatherSymbol = GetWeatherSymbol()
    
    @State var weather: WeatherData?
    
    var body: some View {
        ZStack {
            if let location = manager.location {
                if let weather = weather {
                    VStack(alignment: .trailing, spacing: 10) {
                        HStack(spacing: 100) {
                            Text("\(String(describing: weather.timeSeries[0].parameters[0].values[0])) °C")
                                .fontWeight(.heavy)
                                .font(.system(size: 40))
                                .fontDesign(.rounded)
                                .foregroundStyle(Color.white)
                            
                            weatherSymbol.weatherSymbols[Int(weather.timeSeries[0].parameters[26].values[0]) - 1]
                                .font(.system(size: 50))
                                .symbolRenderingMode(.multicolor)
                            
                        }
                        Text(weatherSymbol.weatherString[Int(weather.timeSeries[0].parameters[26].values[0]) - 1])
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .fontDesign(.rounded)
                            .foregroundStyle(.white)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            LinearGradient(colors: [Color.black, Color.blue], startPoint: .top, endPoint: .bottomTrailing)
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    LocalWeatherView()
}
