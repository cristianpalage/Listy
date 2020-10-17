//
//  ListDetailsEditNameTableViewCell.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-09-11.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit

struct ListDetailsEditNameTableViewCellViewModel {
    var list: Node

    init(list: Node) {
        self.list = list
    }
}

class ListDetailsEditNameTableViewCell: UITableViewCell {

    var viewModel: ListDetailsEditNameTableViewCellViewModel? {
        didSet { setupViewModel() }
    }

    let header: ListyLabel = {
        let label = ListyLabel()
        label.text = "Tap to edit the list name"
        label.font = label.font.withSize(12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let textField: ListyTextField = {
        let tf = ListyTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = tf.font?.withSize(28)
        tf.autocorrectionType = UITextAutocorrectionType.no
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


private extension ListDetailsEditNameTableViewCell {
    func setup() {
        setUpTheming()
        setUpFont()
        contentView.addSubview(textField)
        contentView.addSubview(header)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
        ])

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 6),
            header.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            header.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            header.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            header.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func setupViewModel() {
        textField.text = viewModel?.list.value
    }
}

extension ListDetailsEditNameTableViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        contentView.backgroundColor = theme.backgroundColor
        textField.textColor = theme.textColor
    }
}

extension ListDetailsEditNameTableViewCell: FontProtocol {
    func applyFont(_ font: AppFont) {
        textField.font = font.fontValue().withSize(textField.font?.pointSize ?? 15)
        header.font = font.fontValue().withSize(header.font.pointSize)
    }
}
