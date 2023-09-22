//
//  NotificationManager.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/21.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    private let goalNotificationID = "OneThingNotification"
    static let shared = NotificationManager()
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    var leftTimeByHomeButton: Date? = nil
    
    private init() {}
    
    func requestNotification(date: Date, goalText: String) {
        requestNotificationAuthorization { [weak self] in
            self?.sendNotification(date: date, goalText: goalText)
        }
    }
    
    func dismissNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [goalNotificationID])

    }
    
    func requestNotificationAuthorization(onSuccess: @escaping () -> Void) {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            onSuccess()
        }
    }
    
    func sendNotification(date: Date, goalText: String) {
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = "One Thing"
        notificationContent.body = goalText
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.hour, .minute], from: date), repeats: true)

        let request = UNNotificationRequest(identifier: goalNotificationID, content: notificationContent, trigger: trigger)

        
        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
