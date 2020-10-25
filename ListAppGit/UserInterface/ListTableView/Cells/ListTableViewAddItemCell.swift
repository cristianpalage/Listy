//
//  ListTableViewAddItemCell.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-08-27.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit

class ListTableViewAddItemCell: UITableViewCell {

    let textField: ListyTextField = {
        let tf = ListyTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter list name"
        tf.autocorrectionType = UITextAutocorrectionType.yes
        tf.keyboardType = UIKeyboardType.default
        tf.returnKeyType = UIReturnKeyType.done
        tf.clearButtonMode = UITextField.ViewMode.whileEditing
        tf.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tf
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}


private extension ListTableViewAddItemCell {
    func setup() {
        setUpTheming()
        setUpFont()
        contentView.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}

extension ListTableViewAddItemCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        contentView.backgroundColor = theme.backgroundColor
        textField.textColor = theme.textColor
        textField.tintColor = theme.textColor
    }
}

extension ListTableViewAddItemCell: FontProtocol {
    func applyFont(_ font: AppFont) {
        textField.font = font.fontValue().withSize(17)
    }
}
