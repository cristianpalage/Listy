//
//  UIStackView.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-29.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import UIKit

// MARK: - UIStackView+Subviews

extension UIStackView {

    /// Removes all the subviews from this stack view.
    func removeAllSubviews() {
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
