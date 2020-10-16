//
//  AppThemeProvider.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-15.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import UIKit

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
        theme = SubscribableValue<AppTheme>(value: .light)
    }

    private func setNewTheme(_ newTheme: AppTheme) {
        self.theme.value = newTheme
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
