//
//  Color+Extension.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/08/23.
//

import SwiftUI

public extension Color {

    static let backgroundDark = Color.black
    static let contentBackgroundLight = Color.white
    
    #if os(macOS)
    static let background = Color(NSColor.windowBackgroundColor)
    static let secondaryBackground = Color(NSColor.darkGray)
    static let tertiaryBackground = Color(NSColor.controlBackgroundColor)
    static let titleColor = Color(NSColor.headerTextColor)
    
    static let backgroundLight = Color(NSColor(red: 245, green: 245, blue: 245, alpha: 0))
    static let contentBackgroundDark = Color(NSColor(red: 28, green: 28, blue: 28, alpha: 0))
    #else
    static let background = Color(UIColor.systemBackground)
    static let secondaryBackground = Color(UIColor.systemGray)
    static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
    static let titleColor = Color(UIColor.label)
    
    static let backgroundLight = Color.white
    static let contentBackgroundDark = Color(NSColor(red: 28, green: 28, blue: 28, alpha: 0))
    #endif
}
