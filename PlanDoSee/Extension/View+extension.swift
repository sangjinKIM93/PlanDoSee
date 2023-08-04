//
//  View+extension.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/17.
//

import SwiftUI

extension View {
    func hAlign(_ alignment: Alignment) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
}
