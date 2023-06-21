//
//  SJTextEditor.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/18.
//

import SwiftUI

struct SJTextEditor: View {
    
    @State private var text: String = ""
    
    var body: some View {
        TextEditor(text: $text)
            .font(.system(size: 14))
            .frame(minHeight: 15)
            .fixedSize(horizontal: false, vertical: true)
            .scrollIndicators(.never)
    }
}
