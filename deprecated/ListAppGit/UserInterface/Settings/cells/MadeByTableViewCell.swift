//
//  MadeByTableViewCell.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-19.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit


class MadeByTableViewCell: UITableViewCell {

    private let topLabel: ListyLabel = {
        let label = ListyLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(14)
        label.text = "Made by Cristian Palage in Waterloo, Ontario"
        return label
    }()

    private let bottomLabel: ListyLabel = {
        let label = ListyLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(12)
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        label.text = "Version: \(version) (\(build))"
        return label
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
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


private extension MadeByTableViewCell {
    func setup() {
        setUpTheming()
        setUpFont()

        contentView.addSubview(topLabel)
        contentView.addSubview(bottomLabel)

        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            topLabel.bottomAnchor.constraint(equalTo: bottomLabel.topAnchor, constant: -8),
            topLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            bottomLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bottomLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

    }
}

extension MadeByTableViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        contentView.backgroundColor = theme.secondaryBackgroundColor
        topLabel.textColor = theme.secondaryTextColor
        bottomLabel.textColor = theme.secondaryTextColor
    }
}

extension MadeByTableViewCell: FontProtocol {
    func applyFont(_ font: AppFont) {
        topLabel.font = font.fontValue().withSize(topLabel.font.pointSize)
        bottomLabel.font = font.fontValue().withSize(bottomLabel.font.pointSize)
    }
}

