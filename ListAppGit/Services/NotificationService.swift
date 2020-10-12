//
//  NotificationService.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-11.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UserNotifications

func scheduleNotification(list: Node?) {
    guard let list = list else { return }
    let center = UNUserNotificationCenter.current()

    let content = UNMutableNotificationContent()
    content.title = list.value
    content.categoryIdentifier = "reminder"
    content.userInfo = ["customData": "fizzbuzz"]
    content.sound = UNNotificationSound.default

    var dateComponents = DateComponents()
    dateComponents.hour = 10
    dateComponents.minute = 30
    if let timeUntilNotification = list.deadline?.timeIntervalSinceNow, timeUntilNotification > 0 {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeUntilNotification, repeats: false)
        let request = UNNotificationRequest(identifier: list.id.uuidString, content: content, trigger: trigger)
        center.add(request)
    }
}

func clearNotificationForList(list: Node?, recursive: Bool = false) {
    guard let list = list else { return }

    if recursive {
        for child in list.children {
            clearNotificationForList(list: child)
        }
    }
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [list.id.uuidString])
}
