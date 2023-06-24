//
//  PlanDoSeeInteractor.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/24.
//

import Foundation

class PlanDoSeeInteractor {
    
    func saveTodo(
        date: String,
        task: Task,
        userId: String
    ) {
        FireStoreRepository.shared.saveTodo(
            date: date,
            task: task,
            userId: userId
        )
    }
    
    func getTodo(
        date: String,
        userId: String,
        success: @escaping (([Task]) -> Void)
    ) {
        FireStoreRepository.shared.getTodo(
            date: date,
            userId: userId,
            success: success
        )
    }
}
