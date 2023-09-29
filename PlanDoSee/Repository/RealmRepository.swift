//
//  RealmRepository.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/28.
//

import RealmSwift

class RealmRepository<T: Object> {
    private let realm: Realm = try! Realm()

    func getItem() -> [T] {
        return realm.objects(T.self).map { $0 }
    }
    
    func getItem(filterBy: String) -> [T] {
        
        return realm.objects(T.self).filter(filterBy).map { $0 }
    }

    func get(id: String) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: id)
    }

    func add(item: T) {
        do {
            try realm.write {
                realm.add(item, update: .modified)
            }
        } catch {
            print(error)
        }
    }

    func update(updateItem: @escaping () -> Void) {
        do {
            try realm.write {
                updateItem()
//                realm.add(item, update: .all)
            }
        } catch {
            print(error)
        }
    }

    func delete(item: T) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error)
        }
    }
}
