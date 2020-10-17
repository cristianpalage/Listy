//
//  AppTheme.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-15.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import UIKit

struct AppTheme: Equatable {
    var statusBarStyle: UIStatusBarStyle
    var barBackgroundColor: UIColor
    var barForegroundColor: UIColor
    var backgroundColor: UIColor
    var secondaryBackgroundColor: UIColor
    var textColor: UIColor
    var secondaryTextColor: UIColor
    var tintColor: UIColor
}

extension AppTheme {
    static let light = AppTheme(
        statusBarStyle: .darkContent,
        barBackgroundColor: .white,
        barForegroundColor: .black,
        backgroundColor: .white,
        secondaryBackgroundColor: UIColor(displayP3Red: 240/255, green: 240/255, blue: 240/255, alpha: 1),
        textColor: .black,
        secondaryTextColor: .gray,
        tintColor: .black
    )

    static let dark = AppTheme(
        statusBarStyle: .lightContent,
        barBackgroundColor: UIColor(white: 0, alpha: 1),
        barForegroundColor: .white,
        backgroundColor: .black,
        secondaryBackgroundColor: UIColor(displayP3Red: 15/255, green: 15/255, blue: 15/255, alpha: 1),
        textColor: .white,
        secondaryTextColor: .gray,
        tintColor: .white
    )
}

