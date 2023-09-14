//
//  WeekSeeList.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/09.
//

import SwiftUI

struct WeekSeeList: View {
    
    @State private var sees: [SeeModel] = []
    @State private var weekSeeText: String = ""
    
    @Binding var currentDay: Date
    @AppStorage("user_id") var userId = ""
    
    var body: some View {
        VStack {
            Text("이번주 See")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .font(.headline)
            List {
                ForEach(sees, id: \.self) { seeModel in
                    WeekSeeItemView(date: seeModel.date, text: seeModel.content)
                }
            }
            .listStyle(.plain)
            
            // macos ios 디자인 다르게 가야할듯
            ZStack(alignment: .topLeading) {
                TextEditor(text: $weekSeeText)
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
                    .scrollDisabled(true)
                    .font(.system(size: 16))
                    .padding()
                
                if weekSeeText.isEmpty {
                    Text("한주에 대한 회고를 남겨보세요.")
                        .font(.system(size: 16))
                        .padding(.top, 17)
                        .padding(.leading, 20)
                        .foregroundColor(.primary.opacity(0.25))
                        .allowsHitTesting(false)
                }
            }
        }
        .onAppear {
            getSees { seeModels in
                sees = seeModels
            } failure: {
                //
            }
        }
    }
    
    func getSees(
        success: @escaping ([SeeModel]) -> Void,
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
            success: success,
            failure: failure
        )
    }
}

struct WeekSeeList_Previews: PreviewProvider {
    static var previews: some View {
        WeekSeeList(currentDay: .constant(Date()))
    }
}
