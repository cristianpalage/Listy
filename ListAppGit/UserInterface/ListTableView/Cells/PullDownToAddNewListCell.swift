//
//  PullDownToAddNewListCell.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-09-01.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit

class PullDownToAddNewListCell: UITableViewCell {

    private let label: ListyLabel = {
        let label = ListyLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(14)
        label.textColor = .lightGray
        label.text = "Pull down to add a new list"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setUpTheming()
        setUpFont()
        self.selectionStyle = .none
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


private extension PullDownToAddNewListCell {
    func setup() {
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            label.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}

extension PullDownToAddNewListCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        label.textColor = theme.secondaryTextColor
    }
}

extension PullDownToAddNewListCell: FontProtocol {
    func applyFont(_ font: AppFont) {
        label.font = font.fontValue().withSize(label.font?.pointSize ?? 17)
    }
}

