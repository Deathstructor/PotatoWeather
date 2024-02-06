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
//        let lon = 18
//        let lat = 57
        
//        print(String(describing: lon), String(describing: lat))
        print(lon, lat)
        
        let endpoint = "https://opendata-download-metanalys.smhi.se/api/category/mesan2g/version/1/geotype/point/lon/\(round(10000 * lon) / 10000)/lat/\(round(10000 * lat) / 10000)/data.json"
        guard let url = URL(string: endpoint) else { throw apiError.invalidURL}
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw apiError.invalidResponse }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherData.self, from: data)
        } catch {
            throw apiError.invalidData
        }
    }
    
    
}

struct WeatherData: Decodable {
    let referenceTime: String
    let timeSeries: [TimeSeries]
}

struct TimeSeries: Decodable {
    let parameters: [Parameters]
}

struct Parameters: Decodable {
    let name: String
    let values: [Double]
}

enum apiError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
