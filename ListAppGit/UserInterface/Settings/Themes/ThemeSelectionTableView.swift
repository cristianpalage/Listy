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
            case systemFont
            case newYorkFont
        }

        let rows: [CellType]

        init(rows: [CellType]) {
            self.rows = rows
        }
    }

    fileprivate var sections = [TableViewSection]()
    fileprivate var currentFontNSObject: [NSObject] = []

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
    }

    // MARK: tableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewHeaderView") as! TableViewHeaderView
        var title = ""
        if section == 0 {
            title = "Theme"
        } else if section == 1 {
            title = "Font"
        }
        view.viewModel = TableViewHeaderViewViewModel(title: title)
        return view
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
        case .systemFont:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeSelectionTableViewCell", for: indexPath) as! ThemeSelectionTableViewCell
            cell.viewModel = ThemeSelectionTableViewCellViewModel(theme: "System", isSelected: fontProvider.currentFont == .system)
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
        case .systemFont:
            fontProvider.systemFont()
        case .newYorkFont:
            fontProvider.newYorkFont()
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
        if #available(iOS 14.0, *) {
            self.navigationController?.navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
        }
    }

    func registerTableViewCells() {
        tableView.register(ThemeSelectionTableViewCell.self, forCellReuseIdentifier: "ThemeSelectionTableViewCell")
        tableView.register(TableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: "TableViewHeaderView")
    }

    func configureCellTypes() {

        defer { tableView.reloadData() }

        var sections = [TableViewSection]()
        sections.append(.init(rows: [.light, .dark]))
        sections.append(.init(rows: [.systemFont, .newYorkFont]))
    
        self.sections = sections
    }
}

extension ThemeSelectionTableView: Themed {
    func applyTheme(_ theme: AppTheme) {
        self.tableView.backgroundColor = theme.secondaryBackgroundColor
        self.navigationController?.navigationBar.barTintColor = theme.backgroundColor
        self.navigationController?.navigationBar.tintColor = theme.tintColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.textColor]
        tableView.reloadData()
    }
}

extension ThemeSelectionTableView: FontProtocol {
    func applyFont(_ font: AppFont) {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font.mediumFontValue().withSize(18),
                                                                   NSAttributedString.Key.foregroundColor: themeProvider.currentTheme.textColor]
        navigationController?.navigationItem.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: font.mediumFontValue().withSize(18)], for: .normal)
        tableView.reloadData()
    }
}


