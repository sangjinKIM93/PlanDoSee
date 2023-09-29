//
//  Task.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/18.
//

import Foundation
import RealmSwift

struct Task: Codable, Hashable {
    let id: UUID
    let timeStamp: String
    var title: String
    var isCompleted: Bool
    
    init(id: UUID = .init(),
         timeStamp: String,
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
    
    static func dummyTasks(date: String) -> [Task] {
        return [Task(timeStamp: date)]
    }
    
    func toTaskRealm() -> TaskRealm {
        return TaskRealm(id: self.id,
                         timeStamp: self.timeStamp,
                         title: self.title,
                         isCompleted: self.isCompleted)
    }
}


class TaskRealm: Object, Codable {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var timeStamp: String
    @Persisted var title: String
    @Persisted var isCompleted: Bool
    
    convenience init(id: UUID = .init(),
         timeStamp: String,
         title: String = "",
         isCompleted: Bool = false) {
        self.init()
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(timeStamp, forKey: .timeStamp)
        try container.encode(title, forKey: .title)
        try container.encode(isCompleted, forKey: .isCompleted)
    }
    
    func toTask() -> Task {
        return Task(id: self.id,
                    timeStamp: self.timeStamp,
                    title: self.title,
                    isCompleted: self.isCompleted)
    }
}
