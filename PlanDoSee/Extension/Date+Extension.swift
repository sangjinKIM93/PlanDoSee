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
}

enum DateStyle: String {
    case storeId = "yyyyMMdd"
    case month = "yyyyMM"
}
