//
//  FollowSystemThemeToggleTableViewCell.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-11-29.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit

struct FollowSystemThemeTableViewCellViewModel {

    init() {  }
}

class FollowSystemThemeTableViewCell: UITableViewCell {

    var viewModel: ThemeSelectionTableViewCellViewModel? {
        didSet { setupViewModel() }
    }

    private let useSystemThemeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let useSystemThemeToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setUpToggle()
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


private extension FollowSystemThemeTableViewCell {
    func setup() {
        setUpTheming()
        setUpFont()

        contentView.addSubview(useSystemThemeLabel)
        contentView.addSubview(useSystemThemeToggle)

        NSLayoutConstraint.activate([
            useSystemThemeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            useSystemThemeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            useSystemThemeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

        NSLayoutConstraint.activate([
            useSystemThemeToggle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            useSystemThemeToggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            useSystemThemeToggle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])



    }

    func setupViewModel() {
        useSystemThemeLabel.text = "Use System theme"
    }

    func setUpToggle() {
        self.useSystemThemeToggle.isOn = themeProvider.useSystemThemeBool 
        useSystemThemeToggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
    }

    @objc func toggleChanged(_ sender: UISwitch) {
        themeProvider.useSystemThemeBool = sender.isOn

    }
}

extension FollowSystemThemeTableViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        contentView.backgroundColor = theme.backgroundColor
        useSystemThemeLabel.textColor = theme.textColor
    }
}

extension FollowSystemThemeTableViewCell: FontProtocol {
    func applyFont(_ font: AppFont) {
        useSystemThemeLabel.font = UIFont(name: font.fontDescription, size: useSystemThemeLabel.font.pointSize)
    }
}

