//
//  OneThing.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/21.
//

import Foundation

struct OneThing: Codable, Hashable {
    let id: UUID = .init()
    let goal: String
    let isOnAlarm: Bool
    let alarmDate: String
}
