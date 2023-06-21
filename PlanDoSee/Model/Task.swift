//
//  Task.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/18.
//

import Foundation

struct Task: Hashable {
    let id: UUID = .init()
    var title: String = ""
    var isCompleted: Bool = false
}
