//
//  PullToAddView.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-08-30.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit

class PullToAddView: UIView {
    let textField: ListyTextField = {
        let tf = ListyTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter list name"
        tf.font = tf.font?.withSize(15)
        tf.autocorrectionType = UITextAutocorrectionType.no
        tf.keyboardType = UIKeyboardType.default
        tf.returnKeyType = UIReturnKeyType.done
        tf.clearButtonMode = UITextField.ViewMode.whileEditing
        tf.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tf
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

private extension PullToAddView {
    func setup() {
        setUpTheming()
        addSubview(textField)
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            textField.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}

extension PullToAddView: Themed {
    func applyTheme(_ theme: AppTheme) {
        textField.tintColor = theme.tintColor
    }
}
