//
//  String+Extension.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/21.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateStyle.storeId.rawValue
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
