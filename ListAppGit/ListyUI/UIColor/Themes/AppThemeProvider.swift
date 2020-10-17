//
//  AppThemeProvider.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-15.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import UIKit
import CoreData

final class AppThemeProvider: ThemeProvider {
    static let shared: AppThemeProvider = .init()

    private var theme: SubscribableValue<AppTheme>
    private var availableThemes: [AppTheme] = [.light, .dark]

    var currentTheme: AppTheme {
        get {
            return theme.value
        }
        set {
            setNewTheme(newValue)
        }
    }

    init() {
        theme = SubscribableValue<AppTheme>(value: getSavedTheme())
    }

    private func setNewTheme(_ newTheme: AppTheme) {
        let window = UIApplication.shared.windows.filter{( $0.isKeyWindow )}.first!
        UIView.transition(
            with: window,
            duration: 0.3,
            options: [.transitionCrossDissolve],
            animations: {
                self.theme.value = newTheme
            },
            completion: nil
        )
        saveTheme(theme: newTheme)
    }

    private func saveTheme(theme: AppTheme) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Theme", in: managedContext)!
        let theme = NSManagedObject(entity: entity, insertInto: managedContext)
        var themeString = ""
        if currentTheme == .dark {
            themeString = "dark"
        } else if currentTheme == .light {
            themeString = "light"
        }
        theme.setValue(themeString, forKey: "currentTheme")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func subscribeToChanges(_ object: AnyObject, handler: @escaping (AppTheme) -> Void) {
        theme.subscribe(object, using: handler)
    }

    func darkTheme() {
        currentTheme = .dark
    }

    func lightTheme() {
        currentTheme = .light
    }
}

extension Themed where Self: AnyObject {
    var themeProvider: AppThemeProvider {
        return AppThemeProvider.shared
    }
}

func getSavedTheme() -> AppTheme {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return .light }
    let managedContext = appDelegate.persistentContainer.viewContext
    var themeNSObject: [NSManagedObject] = []
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Theme")
    do {
        themeNSObject = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }

    guard let themeObject = themeNSObject.last else { return .light}
    let theme = themeObject.value(forKeyPath: "currentTheme") as? String ?? "light"
    if theme == "light" {
        return .light
    } else if theme == "dark" {
        return .dark
    }
    return .dark
}

/// Stores a value of type T, and allows objects to subscribe to
/// be notified with this value is changed.
struct SubscribableValue<T> {
    private typealias Subscription = (object: Weak<AnyObject>, handler: (T) -> Void)

    private var subscriptions: [Subscription] = []

    var value: T {
        didSet {
            for (object, handler) in subscriptions where object.value != nil {
                handler(value)
            }
        }
    }

    init(value: T) {
        self.value = value
    }

    mutating func subscribe(_ object: AnyObject, using handler: @escaping (T) -> Void) {
        subscriptions.append((Weak(value: object), handler))
        cleanupSubscriptions()
    }

    /// Removes any subscriptions where the object has been deallocated
    /// and no longer exists
    private mutating func cleanupSubscriptions() {
        subscriptions = subscriptions.filter({ entry in
            return entry.object.value != nil
        })
    }
}

/// A box that allows us to weakly hold on to an object
struct Weak<Object: AnyObject> {
    weak var value: Object?
}
