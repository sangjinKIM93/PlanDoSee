//
//  Task.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/18.
//

import Foundation

struct Task: Codable, Hashable {
    let id: UUID
    let timeStamp: String
    var title: String
    var isCompleted: Bool
    
    init(id: UUID = .init(),
         timeStamp: String = "\(Date().timeIntervalSince1970)",
         title: String = "",
         isCompleted: Bool = false) {
        self.id = id
        self.timeStamp = timeStamp
        self.title = title
        self.isCompleted = isCompleted
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case timeStamp
        case title
        case isCompleted
    }
    
    func dummyTasks() -> [Task] {
        return [Task()]
    }
}
