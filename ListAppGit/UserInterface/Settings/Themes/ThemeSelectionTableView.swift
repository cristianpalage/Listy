//
//  ThemeSelectionTableView.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-15.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit

class ThemeSelectionTableView: UITableViewController {

    struct TableViewSection {

        enum CellType {
            case dark
            case light
            case systemTheme
            case sanFranciscoFont
            case newYorkFont
        }

        let rows: [CellType]

        init(rows: [CellType]) {
            self.rows = rows
        }
    }

    fileprivate var sections = [TableViewSection]()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setUpTheming()
        setUpFont()
        super.viewDidLoad()
        self.setupTableView()
        self.configureCellTypes()
        self.registerTableViewCells()
        self.title = "Theme"

        self.navigationItem.backButtonTitle = "test"
    }

    // MARK: tableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewHeaderView") as! TableViewHeaderView
        var title = ""
        if section == 0 {
            title = "Theme"
        } else if section == 2 {
            title = "Font"
        }
        view.viewModel = TableViewHeaderViewViewModel(title: title)
        return view
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 20
        }
        return 60
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = sections[indexPath.section].rows[indexPath.row]

        switch cellType {
        case .dark:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeSelectionTableViewCell", for: indexPath) as! ThemeSelectionTableViewCell
            cell.viewModel = ThemeSelectionTableViewCellViewModel(theme: "Dark", isSelected: themeProvider.currentTheme == .dark)
            return cell
        case .light:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeSelectionTableViewCell", for: indexPath) as! ThemeSelectionTableViewCell
            cell.viewModel = ThemeSelectionTableViewCellViewModel(theme: "Light", isSelected: themeProvider.currentTheme == .light)
            return cell
        case .systemTheme:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FollowSystemThemeToggleTableViewCell", for: indexPath) as! FollowSystemThemeTableViewCell
            return cell
        case .sanFranciscoFont:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeSelectionTableViewCell", for: indexPath) as! ThemeSelectionTableViewCell
            cell.viewModel = ThemeSelectionTableViewCellViewModel(theme: "San Francisco", isSelected: fontProvider.currentFont == .sanFrancisco)
            return cell
        case .newYorkFont:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeSelectionTableViewCell", for: indexPath) as! ThemeSelectionTableViewCell
            cell.viewModel = ThemeSelectionTableViewCellViewModel(theme: "New York", isSelected: fontProvider.currentFont == .newYork)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = sections[indexPath.section].rows[indexPath.row]

        switch cellType {
        case .dark:
            themeProvider.darkTheme()
        case .light:
            themeProvider.lightTheme()
        case .systemTheme:
            return
        case .sanFranciscoFont:
            fontProvider.setNewFont(font: .sanFrancisco)
        case .newYorkFont:
            fontProvider.setNewFont(font: .newYork)
        }

    }
}

extension ThemeSelectionTableView {

    func configureAndSave() {
        self.configureCellTypes()
        self.tableView.reloadData()
    }
}

// MARK: set up methods

extension ThemeSelectionTableView {

    func setupViewModel() {
        // do something
    }

    func setupTableView() {
        registerTableViewCells()
        tableView.tableFooterView = UIView(frame: .zero)
    }

    func registerTableViewCells() {
        tableView.register(ThemeSelectionTableViewCell.self, forCellReuseIdentifier: "ThemeSelectionTableViewCell")
        tableView.register(FollowSystemThemeTableViewCell.self, forCellReuseIdentifier: "FollowSystemThemeToggleTableViewCell")
        tableView.register(TableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: "TableViewHeaderView")
    }

    func configureCellTypes() {

        defer { tableView.reloadData() }

        var sections = [TableViewSection]()
        sections.append(.init(rows: [.light, .dark]))
        sections.append(.init(rows: [.systemTheme]))
        sections.append(.init(rows: [.sanFranciscoFont, .newYorkFont]))
    
        self.sections = sections
    }
}

extension ThemeSelectionTableView: Themed {
    func applyTheme(_ theme: AppTheme) {
        self.tableView.backgroundColor = theme.secondaryBackgroundColor
        self.navigationController?.navigationBar.barTintColor = theme.barBackgroundColor
        self.navigationController?.navigationBar.tintColor = theme.tintColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.textColor]
        tableView.reloadData()
    }
}

extension ThemeSelectionTableView: FontProtocol {
    func applyFont(_ font: AppFont) {
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: font.mediumFontValue().withSize(17),
            NSAttributedString.Key.foregroundColor: themeProvider.currentTheme.textColor
        ]

        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: font.fontValue().withSize(17),
            NSAttributedString.Key.foregroundColor: self.themeProvider.currentTheme.textColor
        ],
        for: .normal)
        tableView.reloadData()
    }
}


