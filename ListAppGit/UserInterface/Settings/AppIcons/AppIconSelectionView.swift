//
//  AppIconSelectionView.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-24.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit

class AppIconSelectionView: UITableViewController {

    struct TableViewSection {

        enum CellType {
            case red
            case blue
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
        view.viewModel = TableViewHeaderViewViewModel(title: "")
        return view
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = sections[indexPath.section].rows[indexPath.row]

        switch cellType {
        case .red:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeSelectionTableViewCell", for: indexPath) as! ThemeSelectionTableViewCell
            cell.viewModel = ThemeSelectionTableViewCellViewModel(theme: "Red", isSelected: false)
            return cell
        case .blue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeSelectionTableViewCell", for: indexPath) as! ThemeSelectionTableViewCell
            cell.viewModel = ThemeSelectionTableViewCellViewModel(theme: "Blue", isSelected: false)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = sections[indexPath.section].rows[indexPath.row]

        switch cellType {
        case .red:
            return
        case .blue:
            return
        }
    }
}

extension AppIconSelectionView {

    func configureAndSave() {
        self.configureCellTypes()
        self.tableView.reloadData()
    }
}

// MARK: set up methods

extension AppIconSelectionView {

    func setupViewModel() {
        // do something
    }

    func setupTableView() {
        registerTableViewCells()
        tableView.tableFooterView = UIView(frame: .zero)
    }

    func registerTableViewCells() {
        tableView.register(ThemeSelectionTableViewCell.self, forCellReuseIdentifier: "ThemeSelectionTableViewCell")
        tableView.register(TableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: "TableViewHeaderView")
    }

    func configureCellTypes() {

        defer { tableView.reloadData() }

        var sections = [TableViewSection]()
        sections.append(.init(rows: [.red, .blue]))

        self.sections = sections
    }
}

extension AppIconSelectionView: Themed {
    func applyTheme(_ theme: AppTheme) {
        self.tableView.backgroundColor = theme.secondaryBackgroundColor
        self.navigationController?.navigationBar.barTintColor = theme.barBackgroundColor
        self.navigationController?.navigationBar.tintColor = theme.tintColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.textColor]
        tableView.reloadData()
    }
}

extension AppIconSelectionView: FontProtocol {
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



