//
//  SeeView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/07/30.
//

import SwiftUI

struct SeeView: View {
    @StateObject private var seeText = DebounceObject()
    @Binding var showingEvaluationAlert: Bool
    
    @Binding var currentDay: Date
    @AppStorage("user_id") var userId = ""
    
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
                        .lineSpacing(5)
                        .onChange(of: seeText.debouncedText, perform: { newValue in
                            saveSee(see: newValue)
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
        .onAppear {
            getSee { see in
                seeText.isInitialText = true
                seeText.text = see
            } failure: {
                seeText.isInitialText = true
                seeText.text = ""
            }
        }
        .onChange(of: currentDay, perform: { newValue in
            getSee { see in
                seeText.isInitialText = true
                seeText.text = see
            } failure: {
                seeText.isInitialText = true
                seeText.text = ""
            }
        })
    }
}

extension SeeView {
    func saveSee(see: String) {
        FireStoreRepository.shared.saveSee(
            date: currentDay.toString(DateStyle.storeId.rawValue),
            see: see,
            userId: userId
        )
    }
    
    func getSee(
        success: @escaping (String) -> Void,
        failure: @escaping () -> Void
    ) {
        FireStoreRepository.shared.getSee(
            date: currentDay.toString(DateStyle.storeId.rawValue),
            userId: userId,
            success: success,
            failure: failure
        )
    }
}
