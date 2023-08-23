//
//  SeeView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/07/30.
//

import SwiftUI

struct SeeView: View {
    
    @ObservedObject var seeText: DebounceObject
    @Binding var showingEvaluationAlert: Bool
    var saveSee: ((String) -> Void)?
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                HStack {
                    Text("See")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Button {
                        showingEvaluationAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "checklist")
                                .font(.headline)
                                .foregroundColor(.blue.opacity(0.8))
                            Text("Today Score")
                                .foregroundColor(.blue.opacity(0.8))
                                .font(.headline)
                        }
                    }
                    .buttonStyle(.plain)
                }
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $seeText.text)
                        #if os(macOS)
                        .frame(height: 150)
                        #endif
                        .font(.system(size: 16))
                        .scrollIndicators(.never)
                        .onChange(of: seeText.debouncedText, perform: { newValue in
                            saveSee?(newValue)
                        })
                    #if os(iOS)
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
