//
//  UserNotificationsService.swift
//  ios front
//
//  Created by Ilya Derezovskiy on 08.04.2023.
//

import SwiftUI
import UserNotifications

class UserNotificationsService {
    var userID: String? = nil
    static let instance = UserNotificationsService()
    
    func requestAuthorization(userID: String) {
        self.userID = userID
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    func scheduleNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        let tasks: [TaskModel] = NetworkService.shared.getTasks(userID: userID!)
            .filter({ $0.time.toDate("dd MM yyyy HH:mm").toString("dd MM yyyy") == Date().toString("dd MM yyyy")
                && !$0.isDone && !$0.isOverdue})
        
        let content = UNMutableNotificationContent()
        
        content.title = "Сегодня прекрасный день, чтобы выполнить все намеченные дела!"
        
        var subtitle: String = "Задачи на сегодня: "
        for task in tasks {
            subtitle.append(task.title)
            subtitle.append(", ")
        }
        
        if subtitle != "Задачи на сегодня: " {
            subtitle.remove(at: subtitle.lastIndex(of: ",")!)
        }
        
        content.subtitle = subtitle
        content.sound = .default
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        if (subtitle != "Задачи на сегодня: ") {
            UNUserNotificationCenter.current().add(request)
        }
    }
}
