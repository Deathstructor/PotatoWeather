//
//  GetWeatherSymbol.swift
//  PotatoWeather
//
//  Created by Paul Chastain on 2024-02-08.
//

import Foundation
import SwiftUI
import UIKit

class GetWeatherSymbol: ObservableObject {
    var weatherSymbols: [Image] = [
        Image(systemName: "sun.max.fill"),
        Image(systemName: "cloud.sun.fill"),
        Image(systemName: "cloud.sun.fill"),
        Image(systemName: "cloud.sun.fill"),
        Image(systemName: "cloud.fill"),
        Image(systemName: "smoke.fill"),
        Image(systemName: "cloud.fog.fill"),
        Image(systemName: "cloud.drizzle.fill"),
        Image(systemName: "cloud.rain.fill"),
        Image(systemName: "cloud.heavyrain.fill"),
        Image(systemName: "cloud.bolt.rain.fill"),
        Image(systemName: "cloud.sleet.fill"),
        Image(systemName: "cloud.sleet.fill"),
        Image(systemName: "cloud.sleet.fill"),
        Image(systemName: "cloud.snow.fill"),
        Image(systemName: "cloud.snow.fill"),
        Image(systemName: "cloud.snow.fill"),
        Image(systemName: "cloud.drizzle.fill"),
        Image(systemName: "cloud.rain.fill"),
        Image(systemName: "cloud.heavyrain.fill"),
        Image(systemName: "cloud.bolt.fill"),
        Image(systemName: "cloud.sleet.fill"),
        Image(systemName: "cloud.sleet.fill"),
        Image(systemName: "cloud.sleet.fill"),
        Image(systemName: "cloud.snow.fill"),
        Image(systemName: "cloud.snow.fill"),
        Image(systemName: "cloud.snow.fill")
    ]
    
    var weatherString: [String] = [
        "Clear Sky",
        "Nearly Clear Sky",
        "Variable Cloudiness",
        "Halfclear Sky",
        "Cloudy Sky",
        "Overcast",
        "Fog",
        "Light Rain Showers",
        "Moderate Rain Showers",
        "Heavy Rain Showers",
        "Thunderstorm",
        "Light Sleet Showers",
        "Moderate Sleet Showers",
        "Heavy Sleet Showers",
        "Light Snow Showers",
        "Moderate Snow Showers",
        "Heavy Snow Showers",
        "Light Rain",
        "Moderate Rain",
        "Heavy Rain",
        "Thunder",
        "Light Sleet",
        "Moderate Sleet",
        "Heavy Sleet",
        "Light Snowfall",
        "Moderate Snowfall",
        "Heavy Snowfall",
    ]
}
