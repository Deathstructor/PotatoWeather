//
//  ForecastView.swift
//  PotatoWeather
//
//  Created by Paul Chastain on 2024-01-14.
//

import Foundation
import SwiftUI

struct ForecastView: View {
    
    @StateObject var manager = LocationManagerModel()
    @StateObject var fetchWeather = FetchWeatherData()
    @StateObject var weatherSymbol = GetWeatherSymbol()
    @StateObject var getFormattedForecast = ForecastFormatter()
    
    @State var weather: WeatherData?
    @State var forecast: ForecastData?
    
    var body: some View {
        VStack(alignment: .center) {
            
            Text("10-day Forecast")
                .font(.system(size: 40))
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .fontDesign(.rounded)
            
            if let location = manager.location {
                if let weather = weather {
                    if let forecast = forecast {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 10) {
                                if let forecastInfoData = getFormattedForecast.forecastInfoData {
                                    if let forecastTimeData = getFormattedForecast.forecastTimeData {
                                        ForEach(0..<10) { day in
                                            Text(forecastInfoData[day].key)
                                                .font(.system(size: 20))
                                                .fontWeight(.bold)
                                                .foregroundStyle(Color.white)
                                                .fontDesign(.rounded)
                                            
                                            VStack {
                                                ForEach(0..<forecastInfoData[day].value.count, id: \.self) { i in
                                                    HStack(spacing: 50) {
                                                        Text(forecastTimeData[day].value[i].validTime)
                                                            .font(.system(size: 15))
                                                            .fontWeight(.bold)
                                                            .foregroundStyle(Color.white)
                                                            .fontDesign(.rounded)
                                                        
                                                        Text("\(String(describing: forecastInfoData[day].value[i].info.temp)) °C")
                                                            .font(.system(size: 15))
                                                            .fontWeight(.bold)
                                                            .foregroundStyle(Color.white)
                                                            .fontDesign(.rounded)
                                                        
                                                        weatherSymbol.weatherSymbols[Int(forecastInfoData[day].value[i].info.wsymb) - 1]
                                                            .font(.system(size: 25))
                                                            .symbolRenderingMode(.multicolor)
                                                    }
                                                }
                                            }
                                            .padding(.bottom, 50)
                                        }
                                        
                                    } else {
                                        ProgressView()
                                            .task {
                                                getFormattedForecast.formatForecast(location: location, forecast: forecast, weather: weather)
                                            }
                                    }
                                    
                                } else {
                                    ProgressView()
                                        .task {
                                            getFormattedForecast.formatForecast(location: location, forecast: forecast, weather: weather)
                                            print(getFormattedForecast.forecastTimeData?[0].value[0].validTime ?? "no value")
                                        }
                                }
                            }
                        }
                        .frame(height: 600)
                        
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
                else {
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
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    ForecastView()
}
