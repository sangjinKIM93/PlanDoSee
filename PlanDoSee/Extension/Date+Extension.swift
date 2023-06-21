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
        return formatter.string(from: self)
    }
}
