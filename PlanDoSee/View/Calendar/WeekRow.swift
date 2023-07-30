//
//  WeekRow.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/24.
//

import SwiftUI

struct WeekRow: View {
    
    @Binding var currentWeek: [WeekDay]
    @Binding var currentDay: Date
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "chevron.left")
                .onTapGesture {
                    goToBeforeWeek()
                }
            ForEach(currentWeek) { weekDay in
                let status = Calendar.current.isDate(weekDay.date, inSameDayAs: currentDay)
                VStack(spacing: 6) {
                    Text(weekDay.string.prefix(3))
                        .font(.system(size: 12))
                    Text(weekDay.date.toString("dd"))
                        .font(.system(size: 16))
                        .fontWeight(status ? .semibold : .regular)
                }
                .foregroundColor(status ? .blue : .gray)
                .hAlign(.center)
                .contentShape(Rectangle())
                .onTapGesture {
                    currentDay = weekDay.date
                }
            }
            Image(systemName: "chevron.right")
                .onTapGesture {
                    goToNextWeek()
                }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
    }
    
    func goToBeforeWeek() {
        let beforeWeek = Calendar.current.beforeWeek(date: currentDay)
        currentWeek = beforeWeek
        
        if let lastDay = beforeWeek.last {
            currentDay = lastDay.date
        }
    }
    
    func goToNextWeek() {
        let nextWeek = Calendar.current.nextWeek(date: currentDay)
        currentWeek = nextWeek
        
        if let firstDay = nextWeek.first {
            currentDay = firstDay.date
        }
    }
}
