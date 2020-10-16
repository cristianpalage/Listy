//
//  UIView Extensions.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-09-02.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit

// Slight Hack to get Alert Controller to look good in dark mode
extension UIView {
    func searchVisualEffectsSubview() -> UIVisualEffectView? {
        if let visualEffectView = self as? UIVisualEffectView {
            return visualEffectView
        }
        else {
            for subview in subviews {
                if let found = subview.searchVisualEffectsSubview() {
                    return found
                }
            }
        }
        return nil
    }
}
