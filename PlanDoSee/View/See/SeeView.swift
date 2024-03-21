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
    
    @FocusState private var seeViewFocused: Bool
    
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
                        .focused($seeViewFocused)
                        #if os(macOS)
                        .frame(height: 150)
                        .scrollContentBackground(.hidden)
                        .background(Color.tertiaryBackground)
                        #endif
                        .font(.system(size: 16))
                        .scrollIndicators(.never)
                        .lineSpacing(5)
                        .onChange(of: seeText.debouncedText, perform: { newValue in
                            saveSee(see: newValue, date: currentDay)
                        })
//                        .onChange(of: seeViewFocused) { isFocused in
//                            if isFocused == false {
//                                saveSee(see: seeText.text, date: currentDay)
//                            }
//                        }
                    #if os(iOS)
                    if seeText.text.isEmpty {
                        Text("How was your day?")
                            .font(.system(size: 16))
                            .padding(.top, 7)
                            .padding(.leading, 4)
                            .foregroundColor(.primary.opacity(0.25))
                            .allowsHitTesting(false)
                    }
                    #endif
                }
            }
            .scrollDismissesKeyboard(.immediately)
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
        .onChange(of: currentDay, perform: { [currentDay] newValue in
            seeText.stopTimer()
            
            // focus 되어 있으면 저장 - [currentDay] 는 이전 날짜
            if seeViewFocused {
                saveSee(see: seeText.text, date: currentDay)
            }
            getSee { see in
                seeText.isInitialText = true
                seeText.text = see
            } failure: {
                seeText.isInitialText = true
                seeText.text = ""
            }
        })
        // timer로 서버에 저장하는 기능
//        .onChange(of: seeViewFocused) { isFocused in
//            if isFocused {
//                seeText.startTimer()
//            } else {
//                seeText.stopTimer()
//            }
//        }
//        .onReceive(seeText.$prevText) { text in
//            guard !text.isEmpty else { return }
//            saveSee(see: text, date: currentDay)
//        }
    }
}

extension SeeView {
    func saveSee(see: String, date: Date) {
        guard let firstWeekDay = Calendar.current.dateInterval(of: .weekOfMonth, for: currentDay)?.start else {
            return
        }
        FireStoreRepository.shared.saveSee(
            week: firstWeekDay.toString(DateStyle.storeId.rawValue),
            seeModel: SeeModel(date: date.toString(DateStyle.storeId.rawValue), content: see),
            userId: userId
        )
    }
    
    func getSee(
        success: @escaping (String) -> Void,
        failure: @escaping () -> Void
    ) {
        guard let firstWeekDay = Calendar.current.dateInterval(of: .weekOfMonth, for: currentDay)?.start else {
            return
        }
        let currentDayString = currentDay.toString(DateStyle.storeId.rawValue)
        FireStoreRepository.shared.getSee(
            week: firstWeekDay.toString(DateStyle.storeId.rawValue),
            date: currentDayString,
            userId: userId,
            success: { seeModels in
                if let seeModel = seeModels.first(where: { $0.date == currentDayString }) {
                    success(seeModel.content)
                } else {
                    failure()
                }
            },
            failure: failure
        )
    }
}
