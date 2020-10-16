//
//  ListyNavigationController.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-15.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import UIKit

class ListyNavigationController: UINavigationController {
    private var themedStatusBarStyle: UIStatusBarStyle?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return themedStatusBarStyle ?? super.preferredStatusBarStyle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTheming()
    }
}

extension ListyNavigationController: Themed {
    func applyTheme(_ theme: AppTheme) {
        themedStatusBarStyle = theme.statusBarStyle
        setNeedsStatusBarAppearanceUpdate()

        navigationBar.barTintColor = theme.barBackgroundColor
        navigationBar.tintColor = theme.tintColor
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: theme.barForegroundColor
        ]
    }
}
