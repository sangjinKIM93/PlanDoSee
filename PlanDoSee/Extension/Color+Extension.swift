//
//  Color+Extension.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/08/23.
//

import SwiftUI

public extension Color {

    #if os(macOS)
    static let background = Color(NSColor.windowBackgroundColor)
    static let secondaryBackground = Color(NSColor.darkGray)
    static let tertiaryBackground = Color(NSColor.controlBackgroundColor)
    static let titleColor = Color(NSColor.headerTextColor)
    #else
    static let background = Color(UIColor.systemBackground)
    static let secondaryBackground = Color(UIColor.systemGray)
    static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
    static let titleColor = Color(UIColor.label)
    #endif
}
