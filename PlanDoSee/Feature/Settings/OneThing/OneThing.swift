//
//  OneThing.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/21.
//

import Foundation
import RealmSwift

class OneThing: Object, Codable {
    @Persisted(primaryKey: true) var id: UUID = .init()
    @Persisted var goal: String
    @Persisted var isOnAlarm: Bool
    @Persisted var alarmDate: String

    convenience init(id: UUID = .init(), goal: String, isOnAlarm: Bool, alarmDate: String) {
        self.init()
        self.id = id
        self.goal = goal
        self.isOnAlarm = isOnAlarm
        self.alarmDate = alarmDate
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case goal
        case isOnAlarm
        case alarmDate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(goal, forKey: .goal)
        try container.encode(isOnAlarm, forKey: .isOnAlarm)
        try container.encode(alarmDate, forKey: .alarmDate)
    }
}

extension OneThing {
    private static var realm = try! Realm()
    
    static func load() -> Results<OneThing> {
        realm.objects(OneThing.self)
    }
    
    static func add(_ oneThing: OneThing) {
        try! realm.write {
            realm.add(oneThing, update: .modified)
        }
    }
    
    static func delete(_ oneThing: OneThing) {
        try! realm.write {
            realm.delete(oneThing)
        }
    }
}
