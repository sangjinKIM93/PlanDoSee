//
//  TimeLine.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/24.
//

import Foundation

struct TimeLine: Codable, Hashable {
    let id: UUID = .init()
    let hour: String
    var content: String
}
