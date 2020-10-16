//
//  ThemeSelectionTableViewCell.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-15.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit

struct ThemeSelectionTableViewCellViewModel {
    var themeName: String
    var isSelected: Bool

    init(theme: String, isSelected: Bool) {
        self.themeName = theme
        self.isSelected = isSelected
    }
}

class ThemeSelectionTableViewCell: UITableViewCell {

    var viewModel: ThemeSelectionTableViewCellViewModel? {
        didSet { setupViewModel() }
    }

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let checkMarkIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
        imageView.isHidden = true
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


private extension ThemeSelectionTableViewCell {
    func setup() {
        setUpTheming()

        contentView.addSubview(label)
        contentView.addSubview(checkMarkIcon)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)
        ])

        NSLayoutConstraint.activate([
            checkMarkIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            checkMarkIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            checkMarkIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)
        ])

    }

    func setupViewModel() {
        label.text = viewModel?.themeName

        guard let isSelected = viewModel?.isSelected else { return }

        checkMarkIcon.isHidden = !isSelected
    }
}

extension ThemeSelectionTableViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        contentView.backgroundColor = theme.backgroundColor
        label.textColor = theme.textColor
    }
}
