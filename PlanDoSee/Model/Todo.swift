//
//  Task.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/18.
//

import Foundation
import RealmSwift

struct Todo: Codable, Hashable {
    let id: UUID
    let timeStamp: String
    var date: String
    var title: String
    var isCompleted: Bool
    
    init(id: UUID = .init(),
         timeStamp: String = "\(Date().timeIntervalSince1970)",
         date: String,
         title: String = "",
         isCompleted: Bool = false) {
        self.id = id
        self.timeStamp = timeStamp
        self.date = date
        self.title = title
        self.isCompleted = isCompleted
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case timeStamp
        case title
        case isCompleted
        case date
    }
    
    static func dummyTasks(date: String) -> [Todo] {
        return [Todo(date: date)]
    }
    
    func toTaskRealm() -> TaskRealm {
        return TaskRealm(id: self.id,
                         timeStamp: self.timeStamp,
                         date: self.date,
                         title: self.title,
                         isCompleted: self.isCompleted)
    }
}


class TaskRealm: Object, Codable {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var timeStamp: String
    @Persisted var date: String
    @Persisted var title: String
    @Persisted var isCompleted: Bool
    
    convenience init(id: UUID = .init(),
                     timeStamp: String = "\(Date().timeIntervalSince1970)",
                     date: String,
                     title: String = "",
                     isCompleted: Bool = false) {
        self.init()
        self.id = id
        self.timeStamp = timeStamp
        self.date = date
        self.title = title
        self.isCompleted = isCompleted
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case timeStamp
        case title
        case isCompleted
        case date
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(timeStamp, forKey: .timeStamp)
        try container.encode(date, forKey: .date)
        try container.encode(title, forKey: .title)
        try container.encode(isCompleted, forKey: .isCompleted)
    }
    
    func toTask() -> Todo {
        return Todo(id: self.id,
                    timeStamp: self.timeStamp,
                    date: self.date,
                    title: self.title,
                    isCompleted: self.isCompleted)
    }
}
