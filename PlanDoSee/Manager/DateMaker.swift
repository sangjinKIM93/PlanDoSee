//
//  DateMaker.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/07/31.
//

import Foundation

class DateMaker {
    func makeCurrentWeek(evaluations: [String: String], currentDay: Date) -> [WeekDay] {
        guard let firstWeekDay = Calendar.current.dateInterval(of: .weekOfMonth, for: currentDay)?.start else {
            return []
        }
        // 하루씩 더해서 한 주 데이터를 만듬
        var week: [WeekDay] = []
        for index in 0..<7 {
            if let day = Calendar.current.date(byAdding: .day, value: index, to: firstWeekDay) {
                let weekDaySymbol = day.toString("EEEE") // ex) Monday
                let isToday = Calendar.current.isDateInToday(day)
                let evaluationString = evaluations[day.toString("yyyyMMdd"), default: ""]
                var evaluationType: EvaluationType
                if evaluationString.isEmpty {
                    evaluationType = .none
                } else {
                    evaluationType = EvaluationType(rawValue: evaluationString) ?? .none
                }
                
                week.append(
                    .init(string: weekDaySymbol,
                          date: day,
                          evaluation: evaluationType)
                )
            }
        }
        return week
    }
}
