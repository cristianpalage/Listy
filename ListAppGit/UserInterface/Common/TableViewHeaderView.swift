//
//  TableViewHeaderView.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-15.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit

struct TableViewHeaderViewViewModel {
    var title: String

    init(title: String) {
        self.title = title
    }
}

class TableViewHeaderView: UITableViewHeaderFooterView {

    var viewModel: TableViewHeaderViewViewModel? {
        didSet { setupViewModel() }
    }

    let header: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TableViewHeaderView {

    func setup() {
        setUpTheming()
        contentView.addSubview(header)

        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            header.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func setupViewModel() {
        self.header.text = viewModel?.title
    }
}

extension TableViewHeaderView: Themed {
    func applyTheme(_ theme: AppTheme) {
        contentView.backgroundColor = theme.secondaryBackgroundColor
        header.textColor = theme.textColor
    }
}
