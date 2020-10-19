//
//  AppFont.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-16.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation

import UIKit

struct AppFont: Equatable {
    var fontName: String
    var fontDescription: String
}

extension AppFont {
    static let sanFrancisco = AppFont(
        fontName: "San Francisco",
        fontDescription: "SFPro-Regular"
    )

    static let newYork = AppFont(
        fontName: "New York",
        fontDescription: "NewYork-Regular"
    )

    func fontValue() -> UIFont {
        return UIFont(name: fontDescription, size: 1) ?? UIFont.systemFont(ofSize: 1)
    }

    func mediumFontValue() -> UIFont {
        let description = fontDescription.replacingOccurrences(of: "Regular", with: "Medium")
        return UIFont(name: description, size: 1) ?? UIFont.systemFont(ofSize: 1)
    }
}

