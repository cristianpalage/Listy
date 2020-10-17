//
//  FontProtocols.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-16.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation

import Foundation
import UIKit

/// Describes a type that holds a current `Font` and allows
/// an object to be notified when the font is changed.
protocol FontProvider {
    /// Placeholder for the font type that the app will use
    associatedtype Font

    /// The current font that is active
    var currentFont: Font { get }

    /// Subscribe to be notified when the font changes. Handler will be
    /// remove from subscription when `object` is deallocated.
    func subscribeToChanges(_ object: AnyObject, handler: @escaping (Font) -> Void)
}

/// Describes a type that can have a font applied to it
protocol FontProtocol {
    /// A FontProtocol type needs to know about what concrete type the
    /// FontProvider is. So we don't clash with the protocol,
    /// let's call this associated type _FontProvider
    associatedtype _FontProvider: FontProvider

    /// Return the current app-wide font provider
    var fontProvider: _FontProvider { get }

    /// This will be called whenever the current theme changes
    func applyFont(_ font: _FontProvider.Font)
}

extension FontProtocol where Self: AnyObject {
    /// This is to be called once when Self wants to start listening for
    /// font changes. This immediately triggers `applyFont()` with the
    /// current font.
    func setUpFont() {
        applyFont(fontProvider.currentFont)
        fontProvider.subscribeToChanges(self) { [weak self] newFont in
            self?.applyFont(newFont)
        }
    }
}
