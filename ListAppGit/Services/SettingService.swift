//
//  SettingService.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-14.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import CoreData

func getSavedFontDescription() -> String {

    var nsDictionary: NSDictionary?
    if let path = Bundle.main.path(forResource: "settings", ofType: "plist") {
        nsDictionary = NSDictionary(contentsOfFile: path)
        return nsDictionary?["currentFontDescription"] as! String
    }
    return "SFPro-Regular"
}

func getSavedFontName() -> String {
    var nsDictionary: NSDictionary?
    if let path = Bundle.main.path(forResource: "settings", ofType: "plist") {
        nsDictionary = NSDictionary(contentsOfFile: path)
        return nsDictionary?["currentFontName"] as! String
    }
    return "System"
}
