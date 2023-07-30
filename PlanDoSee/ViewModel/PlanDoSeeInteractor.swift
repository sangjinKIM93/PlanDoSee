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
    
    func deleteTodo(
        date: String,
        task: Task,
        userId: String
    ) {
        FireStoreRepository.shared.deleteTodo(
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
    
    func saveTimeline(
        date: String,
        timeLine: TimeLine,
        userId: String
    ) {
        FireStoreRepository.shared.saveTimeline(
            date: date,
            timeLine: timeLine,
            userId: userId
        )
    }
    
    func getTimeLine(
        date: String,
        userId: String,
        success: @escaping (([TimeLine]) -> Void)
    ) {
        FireStoreRepository.shared.getTiemline(
            date: date,
            userId: userId,
            success: success
        )
    }
    
    func saveSee(
        date: String,
        see: String,
        userId: String
    ) {
        FireStoreRepository.shared.saveSee(
            date: date,
            see: see,
            userId: userId
        )
    }
    
    func getSee(
        date: String,
        userId: String,
        success: @escaping ((String) -> Void)
    ) {
        FireStoreRepository.shared.getSee(
            date: date,
            userId: userId,
            success: success
        )
    }
}
