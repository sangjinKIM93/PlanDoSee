//
//  WeekSeeList.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/09.
//

import SwiftUI

struct WeekSeeList: View {
    
    @State private var sees: [SeeModel] = []
    
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
                        .listRowSeparator(.hidden)
                }
//
//                Spacer().frame(height: 10)
//                    .listRowSeparator(.hidden)
                
                WeekSeeReview(currentDay: $currentDay)
            }
            .listStyle(.plain)
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
