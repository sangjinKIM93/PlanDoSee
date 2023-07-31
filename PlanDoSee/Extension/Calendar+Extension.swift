//
//  Calendar+Extension.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/17.
//

import Foundation

extension Calendar {
    var currentHour: Int {
        let date = Date()
        let hour = self.component(.hour, from: date)
        return hour
    }
    
    var hours: [Date] {
        let startOfDay = self.startOfDay(for: Date())
        var hours: [Date] = []
        for index in 0..<24 {
            if let date = self.date(byAdding: .hour, value: index, to: startOfDay) {
                hours.append(date)
            }
        }
        
        return hours
    }
    
    var currentWeek: [WeekDay] {
        // 이번주의 첫째날을 가져옴
        guard let firstWeekDay = self.dateInterval(of: .weekOfMonth, for: Date())?.start else {
            return []
        }
        // 하루씩 더해서 한 주 데이터를 만듬
        var week: [WeekDay] = []
        for index in 0..<7 {
            if let day = self.date(byAdding: .day, value: index, to: firstWeekDay) {
                let weekDaySymbol = day.toString("EEEE") // ex) Monday
                let isToday = self.isDateInToday(day)
                week.append(.init(string: weekDaySymbol, date: day))
            }
        }
        return week
    }
    
    
    func beforeWeek(date: Date) -> [WeekDay] {
        return changeWeek(date: date, added: -7)
    }
    func nextWeek(date: Date) -> [WeekDay] {
        return changeWeek(date: date, added: 7)
    }
    
    func changeWeek(date: Date, added: Int) -> [WeekDay] {
        guard let firstWeekDay = self.dateInterval(of: .weekOfMonth, for: date)?.start else {
            return []
        }
        var week: [WeekDay] = []
        for index in 0..<7 {
            if let day = self.date(byAdding: .day, value: index + added, to: firstWeekDay) {
                let weekDaySymbol = day.toString("EEEE") // ex) Monday
                week.append(.init(string: weekDaySymbol, date: day))
            }
        }
        return week
    }
    
    func startDayOfWeek(date: Date) -> Date {
        return self.dateInterval(of: .weekOfMonth, for: date)?.start ?? Date()
    }
}


struct WeekDay: Identifiable {
    var id: UUID = .init()
    var string: String
    var date: Date
    var isToday: Bool = false
    var evaluation: EvaluationType = .good
}
