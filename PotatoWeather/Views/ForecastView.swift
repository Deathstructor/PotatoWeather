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
    @StateObject var themeHandler = ThemeHandler()
    
    @State var weather: WeatherData?
    @State var forecast: ForecastData?
    
    var body: some View {
        VStack(alignment: .center) {
            
            Text("10-day Forecast")
                .font(.system(size: 40))
                .fontWeight(.bold)
                .foregroundStyle(themeHandler.currentTheme.Text)
                .fontDesign(.rounded)
            
            if let location = manager.location {
                if let weather = weather {
                    if let forecast = forecast {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 10) {
                                if let forecastInfoData = getFormattedForecast.forecastInfoData {
                                    if let forecastTimeData = getFormattedForecast.forecastTimeData {
                                        ForEach(0..<10) { day in
                                            VStack {
                                                VStack {
                                                    Text(forecastInfoData[day].key)
                                                        .font(.system(size: 30))
                                                        .fontWeight(.bold)
                                                        .foregroundStyle(themeHandler.currentTheme.Text)
                                                        .fontDesign(.rounded)
                                                        .padding(.bottom, 5)
                                                        .underline()
                                                    
                                                    ForEach(0..<forecastInfoData[day].value.count, id: \.self) { i in
                                                        VStack(alignment: .center) {
                                                            HStack(spacing: 70) {
                                                                Rectangle().overlay(
                                                                    Text(forecastTimeData[day].value[i].validTime)
                                                                        .font(.system(size: 25))
                                                                        .fontWeight(.bold)
                                                                        .foregroundStyle(themeHandler.currentTheme.Text)
                                                                        .fontDesign(.rounded)
                                                                        .fixedSize(horizontal: true, vertical: false)
                                                                        .monospacedDigit()
                                                                )
                                                                
                                                                Rectangle().overlay(
                                                                    Text("\(String(describing: forecastInfoData[day].value[i].info.temp)) °C")
                                                                        .font(.system(size: 25))
                                                                        .fontWeight(.bold)
                                                                        .foregroundStyle(themeHandler.currentTheme.Text)
                                                                        .fontDesign(.rounded)
                                                                        .fixedSize(horizontal: true, vertical: false)
                                                                )
                                                                
                                                                Rectangle().overlay(
                                                                    weatherSymbol.weatherSymbols[Int(forecastInfoData[day].value[i].info.wsymb) - 1]
                                                                        .font(.system(size: 35))
                                                                        .symbolRenderingMode(.multicolor)
                                                                        .frame(maxWidth: .infinity)
                                                                )
                                                                
                                                            }
                                                            .frame(
                                                                minWidth: 0,
                                                                maxWidth: .infinity,
                                                                minHeight: 35,
                                                                maxHeight: .infinity
                                                            )
                                                            .foregroundStyle(Color.clear)
                                                        }
                                                    }
                                                }
                                                .padding(20)
                                                .background(themeHandler.currentTheme.Accent)
                                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                                .clipped()
                                                .shadow(radius: 5)
                                            }
                                            .padding(.top, 10)
                                            .padding(.bottom, 20)
                                            .padding(.horizontal, 40)
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
                        .frame(height: 700)
                        
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
        .padding(.top, 100)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(themeHandler.currentTheme.Background)
//            LinearGradient(colors: [Color.black, Color.blue], startPoint: .top, endPoint: .bottomTrailing)
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    ForecastView()
}
