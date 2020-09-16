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

    let textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter list name"
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.autocorrectionType = UITextAutocorrectionType.no
        tf.keyboardType = UIKeyboardType.default
        tf.returnKeyType = UIReturnKeyType.done
        tf.clearButtonMode = UITextField.ViewMode.whileEditing
        tf.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
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
        contentView.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            textField.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
