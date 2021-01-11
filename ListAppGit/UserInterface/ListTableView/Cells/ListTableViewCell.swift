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
        didSet {
            setupViewModel()
            setup()
        }
    }

    private let stack: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 4
        return sv
    }()

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
        stack.removeAllSubviews()
        setUpTheming()
        setUpFont()
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])

        stack.addArrangedSubview(label)

        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 24)
        ])

        if viewModel?.list.deadline != nil {
            stack.addArrangedSubview(deadlineLabel)
        }

    }

    func setupViewModel() {
        label.text = viewModel?.list.value
        deadlineLabel.text = dateFormatter(date: viewModel?.list.deadline)?
            .appending(repeatDateFormatter(repeatOption: self.viewModel?.list.repeatOption))
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
