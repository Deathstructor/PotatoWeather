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
    
    func getWeekday(day: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let formatDay = formatter.date(from: day) else { return "no date" }
        let index = Calendar.current.component(.weekday, from: formatDay)
        return Calendar.current.shortWeekdaySymbols[index - 1]
    }
    
    func getTemperatureData() -> [TemperatureData] {
        var allTemperatureData: [TemperatureData] = []
        
        let days = 0..<10;
        for day in days {
            allTemperatureData.append(TemperatureData(
                minTemp: getFormattedForecast.tempMin![day],
                maxTemp: getFormattedForecast.tempMax![day])
            )
        }
        
        return allTemperatureData
    }
    
    var body: some View {
        VStack(alignment: .center) {
            if let location = manager.location {
                if let weather = weather {
                    if let forecast = forecast {
                        ScrollView(.vertical, showsIndicators: false) {
                            if let forecastInfoData = getFormattedForecast.forecastInfoData {
                                ForEach(0..<10) { day in
                                    HStack {
                                        if day == 0 {
                                            Rectangle().overlay(
                                                HStack {
                                                    Text("Now")
                                                        .font(.system(size: 25))
                                                        .fontWeight(.bold)
                                                        .foregroundStyle(themeHandler.currentTheme.Text)
                                                        .fontDesign(.rounded)
                                                        .padding(.bottom, 5)
                                                        .monospaced()
                                                        .fixedSize(horizontal: true, vertical: false)
                                                    Spacer()
                                                }
                                            )
                                            .frame(width: 50)
                                            .scrollTransition(.animated.threshold(.visible(0.8))) { content, phase in
                                                content
                                                    .opacity(phase.isIdentity ? 1 : 0)
                                                    .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                                    .blur(radius: phase.isIdentity ? 0 : 10)
                                            }
                                        } else {
                                            Rectangle().overlay(
                                                HStack {
                                                    Text(String(describing: getWeekday(day: forecastInfoData[day].key)))
                                                        .font(.system(size: 25))
                                                        .fontWeight(.bold)
                                                        .foregroundStyle(themeHandler.currentTheme.Text)
                                                        .fontDesign(.rounded)
                                                        .padding(.bottom, 5)
                                                        .monospaced()
                                                        .fixedSize(horizontal: true, vertical: false)
                                                    Spacer()
                                                }
                                            )
                                            .frame(width: 50)
                                            .scrollTransition(.animated.threshold(.visible(0.8))) { content, phase in
                                                content
                                                    .opacity(phase.isIdentity ? 1 : 0)
                                                    .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                                    .blur(radius: phase.isIdentity ? 0 : 10)
                                            }
                                        }
                                        
                                        Rectangle().overlay(
                                            weatherSymbol.weatherSymbols[getFormattedForecast.mostFrequentWsymb![day] - 1]
                                                .font(.system(size: 35))
                                                .symbolRenderingMode(.multicolor)
                                                .frame(maxWidth: .infinity)
                                        )
                                        .frame(width: 60)
                                        .scrollTransition(.animated.threshold(.visible(0.8))) { content, phase in
                                            content
                                                .opacity(phase.isIdentity ? 1 : 0)
                                                .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                                .blur(radius: phase.isIdentity ? 0 : 10)
                                        }
                                        
                                        VStack(spacing: 0) {
                                            HStack {
                                                Rectangle().overlay(
                                                    Text("\(String(describing: getFormattedForecast.tempMin![day]))°")
                                                        .font(.system(size: 25))
                                                        .foregroundStyle(themeHandler.currentTheme.Text)
                                                        .fontDesign(.rounded)
                                                        .fixedSize(horizontal: true, vertical: false)
                                                        .monospacedDigit()
                                                )
                                                .scrollTransition(.animated.threshold(.visible(0.8))) { content, phase in
                                                    content
                                                        .opacity(phase.isIdentity ? 1 : 0)
                                                        .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                                        .blur(radius: phase.isIdentity ? 0 : 10)
                                                }
                                                
                                                Rectangle().overlay(
                                                    Text("\(String(describing: getFormattedForecast.tempMax![day]))°")
                                                        .font(.system(size: 25))
                                                        .foregroundStyle(themeHandler.currentTheme.Text)
                                                        .fontDesign(.rounded)
                                                        .fixedSize(horizontal: true, vertical: false)
                                                        .monospacedDigit()
                                                )
                                                .scrollTransition(.animated.threshold(.visible(0.8))) { content, phase in
                                                    content
                                                        .opacity(phase.isIdentity ? 1 : 0)
                                                        .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                                        .blur(radius: phase.isIdentity ? 0 : 10)
                                                }
                                                
                                            }

                                            TemperatureBarsView(data: getTemperatureData(), day: day)
                                                .frame(height: 30)
//                                                .background(Color.red)
                                        }
                                    }
                                    .padding(5)
                                    .foregroundStyle(Color.clear)
                                }
                                
                            } else {
                                ProgressView()
                                    .task {
                                        getFormattedForecast.formatForecast(location: location, forecast: forecast, weather: weather)
                                        print(getFormattedForecast.forecastTimeData?[0].value[0].validTime ?? "no value")
                                    }
                            }
                        }
                        .frame(maxHeight: 360)
                        .padding(20)
                        
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
        .background(themeHandler.currentTheme.Accent)
        .clipShape(RoundedRectangle(cornerRadius: 45, style: .circular))
    }
}

#Preview {
    ForecastView()
}
