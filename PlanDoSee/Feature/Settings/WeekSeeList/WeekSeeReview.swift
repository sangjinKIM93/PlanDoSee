//
//  WeekSeeEditor.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/21.
//

import SwiftUI

struct WeekSeeReview: View {
    @StateObject private var weekSeeText = DebounceObject()
    @Binding var currentDay: Date
    @AppStorage("user_id") var userId = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("This week's see")
                .foregroundColor(.blue)
                .font(.system(size: 18))
                .padding(.bottom, 10)
            ZStack(alignment: .topLeading) {
                TextEditor(text: $weekSeeText.text)
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
                    .scrollDisabled(true)
                    .font(.system(size: 16))
                    #if os(macOS)
                    .padding(.top, 7)
                    .scrollContentBackground(.hidden)
                    #endif
                    .onChange(of: weekSeeText.debouncedText, perform: { newValue in
                        saveWeekSee(see: newValue, date: currentDay)
                    })
                
                if weekSeeText.text.isEmpty {
                    Text("Write your retrospect in week.")
                        .font(.system(size: 16))
                        .padding(.top, 6)
                        .padding(.leading, 4)
                        .foregroundColor(.blue.opacity(0.5))
                        .allowsHitTesting(false)
                }
            }
            .listRowSeparator(.hidden)
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.blue.opacity(0.5), lineWidth: 1)
            }
        }
        #if os(macOS)
        .padding()
        #endif
        #if os(iOS)
        .keypadDoneDismiss()
        #endif
        .onAppear {
            getWeekSee { see in
                weekSeeText.isInitialText = true
                weekSeeText.text = see
            } failure: {
                weekSeeText.isInitialText = true
                weekSeeText.text = ""
            }
        }
    }
}

extension WeekSeeReview {
    func saveWeekSee(see: String, date: Date) {
        guard let firstWeekDay = Calendar.current.dateInterval(of: .weekOfMonth, for: currentDay)?.start else {
            return
        }
        FireStoreRepository.shared.saveWeekSee(
            month: firstWeekDay.toString(DateStyle.month.rawValue),
            week: firstWeekDay.toString(DateStyle.storeId.rawValue),
            seeModel: SeeModel(date: date.toString(DateStyle.storeId.rawValue), content: see),
            userId: userId
        )
    }
    
    func getWeekSee(
        success: @escaping (String) -> Void,
        failure: @escaping () -> Void
    ) {
        guard let firstWeekDay = Calendar.current.dateInterval(of: .weekOfMonth, for: currentDay)?.start else {
            return
        }
        let currentDayString = currentDay.toString(DateStyle.storeId.rawValue)
        FireStoreRepository.shared.getWeekSee(
            month: firstWeekDay.toString(DateStyle.month.rawValue),
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

struct WeekSeeReview_Previews: PreviewProvider {
    static var previews: some View {
        WeekSeeReview(currentDay: .constant(Date()))
    }
}
