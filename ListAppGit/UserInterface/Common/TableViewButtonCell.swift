//
//  TableViewButtonCell.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-14.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit

struct TableViewButtonCellViewModel {
    var title: String
    var secondaryTitle: String?

    init(title: String, secondaryTitle: String? = nil) {
        self.title = title
        self.secondaryTitle = secondaryTitle
    }
}

class TableViewButtonCell: UITableViewCell {

    var viewModel: TableViewButtonCellViewModel? {
        didSet { setupViewModel() }
    }

    private let label: ListyLabel = {
        let label = ListyLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(17)
        return label
    }()

    private let secondaryLabel: ListyLabel = {
        let label = ListyLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(17)
        return label
    }()

    private let arrowIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? .systemGray3 : .black

        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setupViewModel()
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


private extension TableViewButtonCell {
    func setup() {
        setUpTheming()
        setUpFont()

        contentView.addSubview(label)
        contentView.addSubview(secondaryLabel)
        contentView.addSubview(arrowIcon)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

        NSLayoutConstraint.activate([
            secondaryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            secondaryLabel.trailingAnchor.constraint(equalTo: arrowIcon.leadingAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            arrowIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18)
        ])
    }

    func setupViewModel() {
        label.text = viewModel?.title
        secondaryLabel.text = viewModel?.secondaryTitle
    }
}

extension TableViewButtonCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        contentView.backgroundColor = theme.backgroundColor
        label.textColor = theme.textColor
        secondaryLabel.textColor = theme.secondaryTextColor
        arrowIcon.tintColor = theme.tintColor
    }
}

extension TableViewButtonCell: FontProtocol {
    func applyFont(_ font: AppFont) {
        label.font = font.fontValue().withSize(label.font.pointSize)
        secondaryLabel.font = font.fontValue().withSize(label.font.pointSize)
    }
}

