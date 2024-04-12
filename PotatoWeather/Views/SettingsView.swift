//
//  SettingsView.swift
//  PotatoWeather
//
//  Created by Paul Chastain on 2024-01-15.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            NavigationStack {
                Text("Settings")
                    .fontWeight(.heavy)
                    .font(.system(size: 50))
                    .fontDesign(.rounded)
                    .padding(.top, 30)
                
                List {
                    NavigationLink("Themes") {
                        ThemesView().navigationTitle("Themes")
                    }
                    Button("Use Farenheit") {
                        
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
