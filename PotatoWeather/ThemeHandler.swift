//
//  ThemesHandler.swift
//  PotatoWeather
//
//  Created by Paul Chastain on 2024-04-08.
//

import Foundation
import SwiftUI

class ThemeHandler: ObservableObject {
    
    @Published var selectedTheme: Int = 0
    @Published var currentTheme: Themes = Themes(
        Background: Color.custom(colorHex: "3b3f4b"),
        Accent: Color.custom(colorHex: "459BED"),
        Text: Color.custom(colorHex: "FFFFFF"),
        TabBar: UIColor.custom(colorHex: "08a0ff"),
        SelectedIcon: UIColor.custom(colorHex: "000000"),
        UnselectedIcon: UIColor.custom(colorHex: "444444")
    )
    
    func setCurrentTheme() {
        switch selectedTheme {
        case 0:
            currentTheme = Themes(
                Background: Color.custom(colorHex: "111111"),
                Accent: Color.custom(colorHex: "08a0ff"),
                Text: Color.custom(colorHex: "ffffff"),
                TabBar: UIColor.custom(colorHex: "08a0ff"),
                SelectedIcon: UIColor.custom(colorHex: "ffffff"),
                UnselectedIcon: UIColor.custom(colorHex: "bbbbbb")
            )
        default:
            currentTheme = Themes(
                Background: Color.custom(colorHex: "485A6E"),
                Accent: Color.custom(colorHex: "2A5CB1"),
                Text: Color.custom(colorHex: "000000"),
                TabBar: UIColor.custom(colorHex: "08a0ff"),
                SelectedIcon: UIColor.custom(colorHex: "000000"),
                UnselectedIcon: UIColor.custom(colorHex: "444444")
            )
        }
    }
}

struct Themes {
    let Background: Color
    let Accent: Color
    let Text: Color
    let TabBar: UIColor
    let SelectedIcon: UIColor
    let UnselectedIcon: UIColor
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, alpha: Double(a) / 255)
    }
    
    static func custom(colorHex: String) -> UIColor {
        return UIColor(hex: colorHex)
    }
    
    func toColor() -> Color {
        return Color(uiColor: self)
    }
}

extension Color {
    static func custom(colorHex: String) -> Color {
        return UIColor(hex: colorHex).toColor()
    }
}
