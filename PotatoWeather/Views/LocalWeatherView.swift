//
//  LocalWeatherView.swift
//  PotatoWeather
//
//  Created by Paul Chastain on 2024-01-14.
//

import SwiftUI
import CoreLocation

struct LocalWeatherView: View {
    
    @StateObject var manager = LocationManagerModel()
    @StateObject var fetchWeather = FetchWeatherData()
    @StateObject var weatherSymbol = GetWeatherSymbol()
    @StateObject var themeHandler = ThemeHandler()
    
    @State var weather: WeatherData?
    @State var forecast: ForecastData?
    
    @State private var showSettings: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let location = manager.location {
                    VStack {
                        HStack(spacing: 250) {
                            Button {
                                
                            } label: {
                                Image("SearchIcon")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .tint(themeHandler.currentTheme.Text)
                            }
                            
                            Button(action: {
                                showSettings = true
                            }) {
                                Image("SettingsIcon")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .rotationEffect(.degrees(90))
                                    .foregroundStyle(Color.white)
                            }
                            .sheet(isPresented: $showSettings) {
                                SettingsView()
                            }
                        }
                        .padding(.bottom, 10)
                        
                        VStack {
                            if let weather = weather {
                                VStack(alignment: .trailing, spacing: 10) {
                                    let weatherSymbolIndex = weather.timeSeries[0].parameters.firstIndex(where: { $0.name == "Wsymb2" })
                                    
                                    HStack(spacing: 100) {
                                        Text("\(String(describing: weather.timeSeries[0].parameters[0].values[0])) °C")
                                            .fontWeight(.heavy)
                                            .font(.system(size: 40))
                                            .fontDesign(.rounded)
                                            .foregroundStyle(themeHandler.currentTheme.Text)
                                            .padding(.top, 30)
                                        
                                        
                                        weatherSymbol.weatherSymbols[Int(weather.timeSeries[0].parameters[weatherSymbolIndex!].values[0]) - 1]
                                            .font(.system(size: 50))
                                            .symbolRenderingMode(.multicolor)
                                        
                                    }
                                    Text(weatherSymbol.weatherString[Int(weather.timeSeries[0].parameters[weatherSymbolIndex!].values[0]) - 1])
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .fontDesign(.rounded)
                                        .foregroundStyle(themeHandler.currentTheme.Text)
                                }
                                .padding(25)
                                .frame(maxWidth: geometry.size.width - 50)
                                .background(themeHandler.currentTheme.Accent)
                                .clipShape(RoundedRectangle(cornerRadius: 45, style: .circular))
                                
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
                        .padding(.bottom, 50)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            if let forecast = forecast {
                                ScrollView(.horizontal) {
                                    HStack(spacing: 30) {
                                        ForEach(0..<24) { day in
                                            VStack(spacing: 20) {
                                                let temperatureIndex = forecast.timeSeries[day].parameters.firstIndex(where: { $0.name == "t" })
                                                
                                                let timeIndex1 = forecast.timeSeries[0].validTime.index(
                                                    forecast.timeSeries[0].validTime.startIndex,
                                                    offsetBy: 11
                                                )
                                                let timeIndex2 = forecast.timeSeries[0].validTime.index(
                                                    forecast.timeSeries[0].validTime.startIndex,
                                                    offsetBy: 13
                                                )
                                                
                                                let time = timeIndex1..<timeIndex2
                                                Rectangle().overlay {
                                                    Text(String(describing: forecast.timeSeries[day].validTime[time]))
                                                        .font(.system(size: 25))
                                                        .fontDesign(.rounded)
                                                        .foregroundStyle(themeHandler.currentTheme.Text)
                                                        .fontDesign(.rounded)
                                                        .monospacedDigit()
                                                        .fixedSize(horizontal: true, vertical: false)
                                                        .fontWeight(.bold)
                                                }
                                                .scrollTransition(.animated.threshold(.visible(0.8))) { content, phase in
                                                    content
                                                        .opacity(phase.isIdentity ? 1 : 0)
                                                        .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                                        .blur(radius: phase.isIdentity ? 0 : 10)
                                                }
                                                
                                                Rectangle().overlay {
                                                    weatherSymbol.weatherSymbols[Int(forecast.timeSeries[day].parameters[18].values[0]) - 1]
                                                        .font(.system(size: 25))
                                                        .symbolRenderingMode(.multicolor)
                                                }
                                                .scrollTransition(.animated.threshold(.visible(0.8))) { content, phase in
                                                    content
                                                        .opacity(phase.isIdentity ? 1 : 0)
                                                        .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                                        .blur(radius: phase.isIdentity ? 0 : 10)
                                                }
                                                
                                                Rectangle().overlay {
                                                    Text("\(String(describing: forecast.timeSeries[day].parameters[temperatureIndex!].values[0]))°")
                                                        .font(.system(size: 25))
                                                        .fontDesign(.rounded)
                                                        .foregroundStyle(themeHandler.currentTheme.Text)
                                                        .fontDesign(.rounded)
                                                        .fixedSize(horizontal: true, vertical: false)
                                                }
                                                .scrollTransition(.animated.threshold(.visible(0.8))) { content, phase in
                                                    content
                                                        .opacity(phase.isIdentity ? 1 : 0)
                                                        .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                                        .blur(radius: phase.isIdentity ? 0 : 10)
                                                }
                                            }
                                            .foregroundStyle(Color.clear)
                                        }
                                        .padding(.vertical, 15)
                                        .padding(.horizontal, 25)
                                    }
                                }
                                .padding(25)
                                .frame(maxWidth: geometry.size.width - 50)
                                .background(themeHandler.currentTheme.Accent)
                                .clipShape(RoundedRectangle(cornerRadius: 45, style: .circular))
                                .scrollTransition(.animated.threshold(.visible(0.9))) { content, phase in
                                    content
                                        .scaleEffect(phase.isIdentity ? 1 : 0.8)
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
                            ForecastView()
                                .frame(maxWidth: geometry.size.width - 50)
                                .scrollTransition(.animated.threshold(.visible(0.9))) { content, phase in
                                    content
                                        .scaleEffect(phase.isIdentity ? 1 : 0.8)
                                }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 700)
            .background(themeHandler.currentTheme.Background)
            Spacer()
        }
    }
}

#Preview {
    LocalWeatherView()
}
