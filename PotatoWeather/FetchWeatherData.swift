//
//  FetchWeatherData.swift
//  PotatoWeather
//
//  Created by Paul Chastain on 2024-02-02.
//

import Foundation
import SwiftUI
import CoreLocation

class FetchWeatherData: ObservableObject {
    
    @StateObject var manager = LocationManagerModel()
    @State var weather: WeatherData?
    
    func getWeatherData(lon: CLLocationDegrees, lat: CLLocationDegrees) async throws -> WeatherData {
        
//        let endpoint = "https://opendata-download-metanalys.smhi.se/api/category/mesan2g/version/1/geotype/point/lon/17/lat/59/data.json"
        let endpoint = "https://opendata-download-metanalys.smhi.se/api/category/mesan2g/version/1/geotype/point/lon/\(round(10000 * lon) / 10000)/lat/\(round(10000 * lat) / 10000)/data.json"
        
        guard let url = URL(string: endpoint) 
        else {
            throw apiError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 
        else {
            throw apiError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherData.self, from: data)
        } catch {
            throw apiError.invalidData
        }
    }
    
    
    
    func getForecastData(lon: CLLocationDegrees, lat: CLLocationDegrees) async throws -> ForecastData {
        
//        let endpoint = "https://opendata-download-metfcst.smhi.se/api/category/pmp3g/version/2/geotype/point/lon/17/lat/59/data.json"
        let endpoint = "https://opendata-download-metfcst.smhi.se/api/category/pmp3g/version/2/geotype/point/lon/\(round(10000 * lon) / 10000)/lat/\(round(10000 * lon) / 10000)/data.json"
        
        guard let url = URL(string: endpoint) 
        else {
            throw apiError.invalidURL
        }
        
        let (data, response) =  try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 
        else {
            throw apiError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(ForecastData.self, from: data)
        } catch {
            throw apiError.invalidData
        }
    }
}

// Get current temperature data from API
struct ForecastData: Decodable {
    let referenceTime: String
    let timeSeries: [TimeSeries]
}

struct WeatherData: Decodable {
    let referenceTime: String
    let timeSeries: [TimeSeries]
}

struct TimeSeries: Decodable {
    let validTime: String
    let parameters: [Parameters]
}

struct Parameters: Decodable {
    let name: String
    let values: [Double]
}

// Errors
enum apiError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
