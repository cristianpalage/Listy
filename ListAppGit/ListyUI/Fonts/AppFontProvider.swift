//
//  AppFontProvider.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-16.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import UIKit
import CoreData

final class AppFontProvider: FontProvider {
    static let shared: AppFontProvider = .init()

    private var font: SubscribableValue<AppFont>
    private var availableFonts: [AppFont] = [.system, .newYork]

    var currentFont: AppFont {
        get {
            return font.value
        }
        set {
            setNewFont(newValue)
        }
    }

    init() {
        font = SubscribableValue<AppFont>(value: getSavedFont())
    }

    private func setNewFont(_ newFont: AppFont) {
        let window = UIApplication.shared.windows.filter{( $0.isKeyWindow )}.first!
        UIView.transition(
            with: window,
            duration: 0.1,
            options: [.transitionCrossDissolve],
            animations: {
                self.font.value = newFont
            },
            completion: nil
        )
        saveFont(font: newFont)
    }

    private func saveFont(font: AppFont) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Font", in: managedContext)!
        let font = NSManagedObject(entity: entity, insertInto: managedContext)
        var fontString = ""
        if currentFont == .system {
            fontString = "system"
        } else if currentFont == .newYork {
            fontString = "newYork"
        }
        font.setValue(fontString, forKey: "currentFont")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func subscribeToChanges(_ object: AnyObject, handler: @escaping (AppFont) -> Void) {
        font.subscribe(object, using: handler)
    }

    func systemFont() {
        currentFont = .system
    }

    func newYorkFont() {
        currentFont = .newYork
    }
}

extension FontProtocol where Self: AnyObject {
    var fontProvider: AppFontProvider {
        return AppFontProvider.shared
    }
}

func getSavedFont() -> AppFont {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return .system }
    let managedContext = appDelegate.persistentContainer.viewContext
    var fontNSObject: [NSManagedObject] = []
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Font")
    do {
        fontNSObject = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }

    guard let fontObject = fontNSObject.last else { return .system}
    let font = fontObject.value(forKeyPath: "currentFont") as? String ?? "system"
    if font == "system" {
        return .system
    } else if font == "newYork" {
        return .newYork
    }
    return .system
}
