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
    content.sound = UNNotificationSound.default

    if let deadline = list.deadline, deadline.timeIntervalSinceNow > 0 {

        var components: DateComponents
        var trigger: UNCalendarNotificationTrigger
        var request: UNNotificationRequest

        if let repeatComponent = list.repeatOption {
            var comps = Set<Calendar.Component>()
            if repeatComponent == .minutely {
                comps = [.second]
            } else if repeatComponent == .hourly {
                comps = [.minute, .second]
            } else if repeatComponent == .daily {
                comps = [.hour, .minute, .second]
            } else if repeatComponent == .weekly {
                comps = [.weekday, .hour, .minute, .second]
            } else if repeatComponent == .monthly {
                comps = [.day, .hour, .minute, .second]
            } else if repeatComponent == .yearly {
                comps = [.month, .day, .hour, .minute, .second]
            }
            components = Calendar.current.dateComponents(comps, from: deadline)
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        } else {
            components = Calendar.current.dateComponents([.era, .year, .month, .day, .hour, .minute, .second], from: deadline)
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        }

        request = UNNotificationRequest(identifier: list.id.uuidString, content: content, trigger: trigger)
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
