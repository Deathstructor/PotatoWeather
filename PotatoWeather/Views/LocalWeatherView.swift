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
    @State var forecast: ForecastData?
    
    var body: some View {
        ZStack {
            if let location = manager.location {
                VStack(spacing: 100) {
                    if let weather = weather {
                        VStack(alignment: .trailing, spacing: 10) {
                            let i = weather.timeSeries[0].parameters.firstIndex(where: { $0.name == "Wsymb2" })
                            HStack(spacing: 100) {
                                Text("\(String(describing: weather.timeSeries[0].parameters[0].values[0])) °C")
                                    .fontWeight(.heavy)
                                    .font(.system(size: 40))
                                    .fontDesign(.rounded)
                                    .foregroundStyle(Color.white)
                                
                                
                                weatherSymbol.weatherSymbols[Int(weather.timeSeries[0].parameters[i!].values[0]) - 1]
                                    .font(.system(size: 50))
                                    .symbolRenderingMode(.multicolor)
                                
                            }
                            Text(weatherSymbol.weatherString[Int(weather.timeSeries[0].parameters[i!].values[0]) - 1])
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
                    
                    if let forecast = forecast {
                        
                        
                        VStack(alignment: .leading) {
                            Text("Forecast")
                                .fontWeight(.heavy)
                                .font(.system(size: 30))
                                .fontDesign(.rounded)
                                .foregroundStyle(Color.white)
                            ScrollView(.vertical, showsIndicators: false) {
                                ForEach(0..<24) { day in
                                    HStack(spacing: 100) {
                                        let i = forecast.timeSeries[day].parameters.firstIndex(where: { $0.name == "t" })
                                        
                                        let timeIndex1 = forecast.timeSeries[0].validTime.index(
                                            forecast.timeSeries[0].validTime.startIndex,
                                            offsetBy: 11
                                        )
                                        let timeIndex2 = forecast.timeSeries[0].validTime.index(
                                            forecast.timeSeries[0].validTime.startIndex,
                                            offsetBy: 13
                                        )
                                        
                                        let index = timeIndex1..<timeIndex2
                                        
                                        Text(String(describing: forecast.timeSeries[day].validTime[index]))
                                            .font(.system(size: 25))
                                            .fontDesign(.rounded)
                                            .foregroundStyle(Color.white)
                                        
                                        Text("\(String(describing: forecast.timeSeries[day].parameters[i!].values[0])) °C")
                                            .font(.system(size: 25))
                                            .fontDesign(.rounded)
                                            .foregroundStyle(Color.white)
                                        
                                        weatherSymbol.weatherSymbols[Int(forecast.timeSeries[day].parameters[18].values[0]) - 1]
                                            .font(.system(size: 25))
                                            .symbolRenderingMode(.multicolor)
                                    }
                                }
                            }
                            .frame(height: 345)
                            
                        }
                        
                    } else {
                        ProgressView()
                            .task {
                                do {
                                    forecast = try await fetchWeather.getForecastData(
                                        lon: location.longitude,
                                        lat: location.latitude
                                    )
                                } catch {
                                    print("Error getting forecast data: ", error)
                                }
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
