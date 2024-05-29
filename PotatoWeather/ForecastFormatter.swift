//
//  ForecastFormatter.swift
//  PotatoWeather
//
//  Created by Paul Chastain on 2024-02-20.
//

import Foundation
import SwiftUI
import CoreLocation

class ForecastFormatter: ObservableObject {
    
    @StateObject var weatherSymbol = GetWeatherSymbol()
    
    @Published var forecastInfoData: [Dictionary<String, [ForecastDates]>.Element]?
    @Published var forecastTimeData: [Dictionary<String, [ForecastTime]>.Element]?
    @Published var tempMin: [Double]?
    @Published var tempMax: [Double]?
    @Published var mostFrequentWsymb: [Int]?
    
    var hasLoaded: Bool = false
    
    func formatForecast(location: CLLocationCoordinate2D, forecast: ForecastData?, weather: WeatherData?) {
        
        if hasLoaded == false {
            let dateIndex1 = forecast!.timeSeries[0].validTime.index(
                forecast!.timeSeries[0].validTime.startIndex,
                offsetBy: 0
            )
            let dateIndex2 = forecast!.timeSeries[0].validTime.index(
                forecast!.timeSeries[0].validTime.startIndex,
                offsetBy: 10
            )
            
            let date = dateIndex1..<dateIndex2
            
            let timeIndex1 = forecast!.timeSeries[0].validTime.index(
                forecast!.timeSeries[0].validTime.startIndex,
                offsetBy: 11
            )
            let timeIndex2 = forecast!.timeSeries[0].validTime.index(
                forecast!.timeSeries[0].validTime.startIndex,
                offsetBy: 13
            )
            
            let time = timeIndex1..<timeIndex2
            
            var allForecastInfo: [ForecastDates] = []
            var allForecastTimes: [ForecastTime] = []
            for day in 0..<forecast!.timeSeries.count {
                
                let temperatureIndex = forecast!.timeSeries[day].parameters.firstIndex(where: { $0.name == "t" })
                let weatherSymbolIndex = forecast!.timeSeries[day].parameters.firstIndex(where: { $0.name == "Wsymb2" })
                
                allForecastInfo.append(ForecastDates(
                    date: String("\(forecast!.timeSeries[day].validTime[date])"),
                    info: ForecastInfo(
                        temp: forecast!.timeSeries[day].parameters[temperatureIndex!].values[0],
                        wsymb: forecast!.timeSeries[day].parameters[weatherSymbolIndex!].values[0]
                    )
                ))
                
                allForecastTimes.append(ForecastTime(
                    date: String("\(forecast!.timeSeries[day].validTime[date])"),
                    validTime: String("\(forecast!.timeSeries[day].validTime[time])")
                ))
            }
            
            let groupedInfo = Dictionary(grouping: allForecastInfo, by: { $0.date })
            let groupedTimes = Dictionary(grouping: allForecastTimes, by: { $0.date })
            
            let sortedGroupedInfo = groupedInfo.sorted(by: { $0.0 < $1.0 })
            let sortedGroupedTimes = groupedTimes.sorted(by: { $0.0 < $1.0 })
            
            forecastInfoData = sortedGroupedInfo
            forecastTimeData = sortedGroupedTimes
            
            
            var allTempsMin: [Double] = []
            var allTempsMax: [Double] = []
            var mostFrequentWeather: [Int] = []
            
            let days = 0..<10
            for day in days {
                var allTemps: [Double] = []
                var allWeathers: [Int] = []
                
                let temperatures = 0..<forecastInfoData![day].value.count
                for i in temperatures {
                    allTemps.append(Double(forecastInfoData![day].value[i].info.temp))
                    allWeathers.append(Int(forecastInfoData![day].value[i].info.wsymb))
                }
                
                allTempsMin.append(allTemps.min()!)
                allTempsMax.append(allTemps.max()!)
                
                var counts = [Int: Int]()
                
                allWeathers.forEach { counts[$0] = (counts[$0] ?? 0) + 1}
                
                if let (_, value) = counts.max(by: { $0.1 < $1.1 }) {
                    mostFrequentWeather.append(value)
                }
            }
            
            tempMin = allTempsMin
            tempMax = allTempsMax
            mostFrequentWsymb = mostFrequentWeather
            
            hasLoaded = true
        }
    }
}

struct ForecastDates {
    let date: String
    let info: ForecastInfo
}

struct ForecastInfo {
    let temp: Double
    let wsymb: Double
}

struct ForecastTime {
    let date: String
    let validTime: String
}
