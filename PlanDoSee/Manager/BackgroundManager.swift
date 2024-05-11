//
//  BackgroundManager.swift
//  PlanDoSee
//
//  Created by 김상진 on 5/11/24.
//

import UIKit
import UserNotifications
import BackgroundTasks
import SwiftUI

class BackgroundManager {
    @AppStorage("user_id") var userId = ""
    
    func registerBackgroundTask() {
        // 백그라운드 작업 등록
        let backgroundTaskIdentifier = "com.PlanDoSee.todoalarm"
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskIdentifier, using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        // 백그라운드 작업 스케줄링
        scheduleBackgroundTask()
    }

    func handleAppRefresh(task: BGAppRefreshTask) {
        // 로컬 알림 보내기
        checkListAndSendNotification()
        
        // 백그라운드 작업 완료
        task.setTaskCompleted(success: true)
    }
    
    func scheduleBackgroundTask() {
        let request = BGAppRefreshTaskRequest(identifier: "com.PlanDoSee.todoalarm")
        request.earliestBeginDate = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("백그라운드 작업 스케줄링 실패: \(error)")
        }
    }
    
    func checkListAndSendNotification() {
        // 리스트를 어떻게 받아올까?
        FireStoreRepository.shared.getTodo(
            date: Date().toString(DateStyle.storeId.rawValue), 
            userId: userId) { todos in
                if todos.isEmpty {
                    let oneMinuteFromNow = Calendar.current.date(byAdding: .minute, value: 1, to: Date()) ?? Date()
                    NotificationManager.shared.requestNotification(date: oneMinuteFromNow, type: .oneThing, body: "todo 리스트를 작성해보아요.")
                }
            } failure: {
                print("error")
            }
    }
}
