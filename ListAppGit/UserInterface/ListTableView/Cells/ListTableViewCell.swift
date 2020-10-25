//
//  ListTableViewCell.swift
//  listAppGit
//
//  Created by Cristian Palage on 2020-08-23.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit

struct ListTableViewCellViewModel {
    var list: Node

    init(list: Node) {
        self.list = list
    }
}

class ListTableViewCell: UITableViewCell {

    var viewModel: ListTableViewCellViewModel? {
        didSet { setupViewModel() }
    }
    
    private let label: ListyLabel = {
        let label = ListyLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let deadlineLabel: ListyLabel = {
        let label = ListyLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        return label
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


private extension ListTableViewCell {
    func setup() {
        setUpTheming()
        setUpFont()
        contentView.addSubview(label)
        contentView.addSubview(deadlineLabel)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            deadlineLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
            deadlineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            deadlineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            deadlineLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
        ])
    }

    func setupViewModel() {
        label.text = viewModel?.list.value
        deadlineLabel.text = dateFormatter(date: viewModel?.list.deadline)
    }
}

extension ListTableViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        contentView.backgroundColor = theme.backgroundColor
        label.textColor = theme.textColor
    }
}

extension ListTableViewCell: FontProtocol {
    func applyFont(_ font: AppFont) {
        label.font = font.fontValue().withSize(17)
        deadlineLabel.font = font.fontValue().withSize(11)
    }
}
