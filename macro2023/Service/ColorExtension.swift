//
//  ColorExt.swift
//  macro2023
//
//  Created by Shalomeira Winata on 12/10/23.
//

import SwiftUI


extension Color {
    static let systemGray = Color(UIColor.systemGray.cgColor)
    static let systemGray2 = Color(UIColor.systemGray2.cgColor)
    static let systemGray3 = Color(UIColor.systemGray3.cgColor)
    static let systemGray4 = Color(UIColor.systemGray4.cgColor)
    static let systemGray5 = Color(UIColor.systemGray5.cgColor)
    static let systemGray6 = Color(UIColor.systemGray6.cgColor)
}
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
