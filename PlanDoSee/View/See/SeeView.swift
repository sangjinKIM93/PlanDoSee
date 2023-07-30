//
//  SeeView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/07/30.
//

import SwiftUI

struct SeeView: View {
    
    @ObservedObject var seeText: DebounceObject
    var saveSee: ((String) -> Void)?
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("See")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button("오늘 하루 평가하기") {
                    print("팝업 띄우기")
                }
            }
            TextEditor(text: $seeText.text)
                .frame(height: 150)
                .font(.system(size: 16))
                .onChange(of: seeText.debouncedText, perform: { newValue in
                    saveSee?(newValue)
                })
        }
    }
}
