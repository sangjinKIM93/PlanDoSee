//
//  NotificationManager.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/21.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    enum type: String {
        case oneThing = "oneThing"
        case todoRequest = "todoRequest"
        
        func getTitle() -> String {
            switch self {
            case .oneThing:
                return "OneThing"
            case .todoRequest:
                return "오늘의 Todo"
            }
        }
    }
    private let goalNotificationID = "OneThingNotification"
    static let shared = NotificationManager()
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    var leftTimeByHomeButton: Date? = nil
    
    private init() {}
    
    func requestNotification(date: Date, type: NotificationManager.type, body: String) {
        requestNotificationAuthorization { [weak self] in
            self?.sendNotification(date: date, type: type, body: body)
        }
    }
    
    func dismissNotification(type: NotificationManager.type) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [type.rawValue])
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
    
    func sendNotification(date: Date, type: NotificationManager.type, body: String) {
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = type.getTitle()
        notificationContent.body = body
        
        let isRepeated: Bool = type == .oneThing ? true : false
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.hour, .minute], from: date), repeats: isRepeated)

        let request = UNNotificationRequest(identifier: type.rawValue, content: notificationContent, trigger: trigger)

        
        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
