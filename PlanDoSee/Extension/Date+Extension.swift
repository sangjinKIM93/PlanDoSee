//
//  Date+Extension.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/17.
//

import Foundation

extension Date {
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: self)
    }
    
    func addDays(add: Int) -> Date {
        guard let modifiedDate = Calendar.current.date(byAdding: .day, value: add, to: self) else {
            return self
        }
        return modifiedDate
    }
}

enum DateStyle: String {
    case storeId = "yyyyMMdd"
    case month = "yyyyMM"
}
