//
//  TemperatureBarsView.swift
//  PotatoWeather
//
//  Created by Paul Chastain on 2024-05-29.
//

import SwiftUI

struct TemperatureBarsView: View {
    var data: [TemperatureData]
    var day: Int
    
    var body: some View {
        let minTempRange = data.map { $0.minTemp }.min() ?? 0
        let maxTempRange = data.map { $0.maxTemp }.max() ?? 0
        
        HStack(alignment: .bottom, spacing: 0) {
            TemperatureBarView(
                minTemp: data[day].minTemp,
                maxTemp: data[day].maxTemp,
                minTempRange: minTempRange,
                maxTempRange: maxTempRange
            )
            .frame(width: 0, height: 150)
        }
        .rotationEffect(.degrees(90))
    }
}

struct TemperatureData: Identifiable {
    let id = UUID()
    let minTemp: Double
    let maxTemp: Double
}

struct TemperatureBarsView_Previews: PreviewProvider {
    static var previews: some View {
        // Placeholder data for the preview
        let placeholderData = [
            TemperatureData(minTemp: 10, maxTemp: 20),
            TemperatureData(minTemp: 12, maxTemp: 22),
            TemperatureData(minTemp: 8, maxTemp: 18),
            TemperatureData(minTemp: 14, maxTemp: 24),
            TemperatureData(minTemp: 16, maxTemp: 26)
        ]
        
        TemperatureBarsView(data: placeholderData, day: 0)
    }
}

//#Preview {
//    TemperatureBarsView()
//}
