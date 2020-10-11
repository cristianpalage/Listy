//
//  NotificationService.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-11.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UserNotifications

func scheduleNotification() {
    let center = UNUserNotificationCenter.current()

    let content = UNMutableNotificationContent()
    content.title = "Late wake up call"
    content.body = "The early bird catches the worm, but the second mouse gets the cheese."
    content.categoryIdentifier = "alarm"
    content.userInfo = ["customData": "fizzbuzz"]
    content.sound = UNNotificationSound.default

    var dateComponents = DateComponents()
    dateComponents.hour = 10
    dateComponents.minute = 30
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    center.add(request)
}
