//
//  Task.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/18.
//

import Foundation

struct Task: Codable, Hashable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    
    init(id: UUID = .init(), title: String = "", isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case isCompleted
    }
}
