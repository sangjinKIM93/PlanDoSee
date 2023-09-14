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
                        .listRowSeparator(.hidden)
                }
//
//                Spacer().frame(height: 10)
//                    .listRowSeparator(.hidden)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("이번주 회고")
                        .foregroundColor(.blue)
                        .font(.system(size: 18))
                        .padding(.bottom, 10)
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $weekSeeText)
                            .frame(height: 150)
                            .frame(maxWidth: .infinity)
                            .scrollDisabled(true)
                            .font(.system(size: 16))
                            #if os(macOS)
                            .padding(.top, 7)
                            #endif
                        
                        if weekSeeText.isEmpty {
                            Text("한주에 대한 회고를 남겨보세요.")
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
