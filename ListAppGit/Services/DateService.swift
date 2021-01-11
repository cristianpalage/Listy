//
//  DateService.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-04.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation

func dateFormatter(date: Date?, dateFormat: String? = "EEEE, d MMM yyyy h:mm a") -> String? {
    guard let date = date else { return nil }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat

    return dateFormatter.string(from: date)
}

func repeatDateFormatter(repeatOption: RepeatOption?) -> String {
    
    guard let repeatOption = repeatOption else { return "" }

    switch repeatOption {
    case .minutely:
        return " repeating every Minute"
    case .hourly:
        return " repeating Hourly"
    case .daily:
        return " repeating Daily"
    case .weekly:
        return " repeating Weekly"
    case .monthly:
        return " repeating Monthly"
    case .yearly:
        return " repeating Yearly"
    }
}
