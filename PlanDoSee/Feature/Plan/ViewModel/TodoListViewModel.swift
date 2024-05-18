//
//  TodoListViewModel.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/28.
//

import Foundation
import SwiftUI
import RealmSwift

class TodoListViewModel: ObservableObject {
//    let realmRepository = RealmRepository<TaskRealm>()
    let firebaseRepository = FireStoreRepository.shared
    
    @AppStorage("user_id") var userId = ""
    var currentDay: String? = nil
    
    func saveTodo(
        task: Todo,
        date: String
    ) async {
//        realmRepository.add(item: task.toTaskRealm())
        
        // 네트워크
        return await withCheckedContinuation { continuation in
            firebaseRepository.saveTodo(
                date: date,
                task: task,
                userId: userId) {
                    continuation.resume()
                } failure: {
                    continuation.resume()
                }
        }
    }
    
    func deleteTodo(
        task: Todo,
        date: String
    ) async {
//        realmRepository.delete(item: task.toTaskRealm())
        
        return await withCheckedContinuation { continuation in
            firebaseRepository.deleteTodo(
                date: date,
                task: task,
                userId: userId) {
                    continuation.resume()
                } failure: {
                    continuation.resume()
                }
        }
    }
    
    func getTask(date: String, completion: @escaping ([Todo]) -> Void) {
        self.getTaskAPI(date: date) { tasks in
            completion(tasks)
        } failure: { [weak self] in
//            guard let self = self else {
//                completion([])
//                return
//            }
//            let tasks = self.getTaskRealm(date: date)
//            completion(tasks)
            completion([])
        }
    }
    
//    func getTaskRealm(date: String) -> [Todo] {
//        let filter = String(format: "timeStamp == %@", date)
//        return realmRepository.getItem(filterBy: filter).map { $0.toTask() }
//    }
    
    func getTaskAPI(
        date: String,
        success: @escaping ([Todo]) -> Void,
        failure: @escaping () -> Void
    ) {
        FireStoreRepository.shared.getTodo(
            date: date,
            userId: userId,
            success: success,
            failure: failure
        )
    }
}
