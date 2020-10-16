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
    var tintColor: UIColor

    
}

extension AppTheme {
    static let light = AppTheme(
        statusBarStyle: .darkContent,
        barBackgroundColor: .white,
        barForegroundColor: .black,
        backgroundColor: .white,
        secondaryBackgroundColor: .systemGray6,
        textColor: .black,
        tintColor: .black
    )

    static let dark = AppTheme(
        statusBarStyle: .lightContent,
        barBackgroundColor: UIColor(white: 0, alpha: 1),
        barForegroundColor: .white,
        backgroundColor: .black,
        secondaryBackgroundColor: .systemGray2,
        textColor: .white,
        tintColor: .white
    )
}

