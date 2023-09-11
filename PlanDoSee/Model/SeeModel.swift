//
//  SeeModel.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/07/30.
//

import Foundation

struct SeeModel: Codable, Hashable {
    let id: UUID = .init()
    let date: Date
    let content: String
    let Evaluation: String
}
