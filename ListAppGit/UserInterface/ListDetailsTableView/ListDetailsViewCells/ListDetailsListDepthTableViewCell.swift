//
//  ListDetailsListDepthTableViewCell.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-09-13.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit

struct ListDetailsListDepthTableViewCellViewModel {
    var list: Node

    init(list: Node) {
        self.list = list
    }
}

class ListDetailsListDepthTableViewCell: UITableViewCell {

    var viewModel: ListDetailsListDepthTableViewCellViewModel? {
        didSet { setupViewModel() }
    }

    let header: ListyLabel = {
        let label = ListyLabel()
        label.font = label.font.withSize(15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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


private extension ListDetailsListDepthTableViewCell {
    func setup() {
        setUpTheming()
        contentView.addSubview(header)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            header.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            header.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            header.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            header.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    func setupViewModel() {
        if let depth = viewModel?.list.depth() {
            header.text = "List depth: \(depth)"
        }
    }
}

extension ListDetailsListDepthTableViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        contentView.backgroundColor = theme.backgroundColor
        header.textColor = theme.textColor
    }
}
