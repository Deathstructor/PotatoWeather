//
//  ThemesView.swift
//  PotatoWeather
//
//  Created by Paul Chastain on 2024-03-01.
//

import SwiftUI

struct ThemesView: View {
    
    @StateObject var themeHandler = ThemeHandler()
    
    var body: some View {
        Text("Placeholder")
            .onAppear {
                themeHandler.setCurrentTheme()
            }
    }
}

#Preview {
    ThemesView()
}
