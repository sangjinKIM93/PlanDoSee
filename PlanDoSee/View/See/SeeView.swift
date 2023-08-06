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
        ZStack {
            VStack(spacing: 10) {
                Text("See")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $seeText.text)
                        #if os(macOS)
                        .frame(height: 150)
                        #endif
                        .font(.system(size: 16))
                        .onChange(of: seeText.debouncedText, perform: { newValue in
                            saveSee?(newValue)
                        })
                    #if os(macOS)
                    if seeText.text.isEmpty {
                        Text("오늘 하루 어땠나요?")
                            .font(.system(size: 16))
                            .padding(.top, 7)
                            .padding(.leading, 4)
                            .foregroundColor(.primary.opacity(0.25))
                            .allowsHitTesting(false)
                    }
                    #endif
                }
            }
        }
    }
}
