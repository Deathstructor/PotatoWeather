//
//  TemperatureBarView.swift
//  PotatoWeather
//
//  Created by Paul Chastain on 2024-05-29.
//

import SwiftUI

struct TemperatureBarView: View {
    var minTemp: Double?
    var maxTemp: Double?
    var minTempRange: Double?
    var maxTempRange: Double?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottom) {
                    Capsule()
                        .fill(Color.white.opacity(0.4))
                        .frame(width: 10, height: geometry.size.height)
                    
                    if let minTemp = minTemp, let maxTemp = maxTemp, let minTempRange = minTempRange, let maxTempRange = maxTempRange {
                        let totalRange = maxTempRange - minTempRange
                        let normalizedMinTemp = (minTemp - minTempRange) / totalRange
                        let normalizedMaxTemp = (maxTemp - minTempRange) / totalRange
                        
                        let capsuleHeight = (normalizedMaxTemp - normalizedMinTemp) * geometry.size.height
                        let capsuleOffset = (minTemp - minTempRange) / totalRange * geometry.size.height
                        
                        let minColor = colorForTemperature(minTemp)
                        let maxColor = colorForTemperature(maxTemp)
                        
                        Capsule()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [minColor, maxColor]),
                                startPoint: .bottom,
                                endPoint: .top
                            ))
                            .frame(
                                width: 10,
                                height: capsuleHeight
                            )
                            .offset(y: -capsuleOffset)
                    }
                }
            }
        }
    }
    
    // Function to determine color based on temperature
    private func colorForTemperature(_ temperature: Double) -> Color {
        switch temperature {
        case ..<(-20):
            return Color(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 255.0 / 255.0)
        case -20..<(-15):
            return Color(red: 0.0 / 255.0, green: 50.0 / 255.0, blue: 255.0 / 255.0)
        case -15..<(-10):
            return Color(red: 0.0 / 255.0, green: 125.0 / 255.0, blue: 255.0 / 255.0)
        case -10..<(-5):
            return Color(red: 0.0 / 255.0, green: 200.0 / 255.0, blue: 255.0 / 255.0)
        case -5..<0:
            return Color(red: 30.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0)
        case 0..<5:
            return Color(red: 70.0 / 255.0, green: 255.0 / 255.0, blue: 200.0 / 255.0)
        case 5..<10:
            return Color(red: 255 / 255.0, green: 255 / 255.0, blue: 150.0 / 255.0)
        case 10..<15:
            return Color(red: 200.0 / 255.0, green: 255.0 / 255.0, blue: 0.0 / 255.0)
        case 15..<20:
            return Color(red: 255.0 / 255.0, green: 220.0 / 255.0, blue: 0.0 / 255.0)
        case 20..<25:
            return Color(red: 255.0 / 255.0, green: 150.0 / 255.0, blue: 0.0 / 255.0)
        case 20..<30:
            return Color(red: 255.0 / 255.0, green: 100.0 / 255.0, blue: 0.0 / 255.0)
        default:
            return Color(red: 255.0 / 255.0, green: 50.0 / 255.0, blue: 0.0 / 255.0)
        }
    }
}

struct TemperatureColor {
    let temperature: Double
    let color: Color
}

#Preview {
    TemperatureBarView()
}
