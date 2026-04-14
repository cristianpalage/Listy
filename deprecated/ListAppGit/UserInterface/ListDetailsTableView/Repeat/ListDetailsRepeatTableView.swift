//
//  ListDetailsRepeatTableView.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2021-01-10.
//  Copyright © 2021 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit

struct ListDetailsRepeatTableViewViewModel {
    let currentList: Node

    init(currentList: Node) {
        self.currentList = currentList
    }
}

protocol ListDetailsRepeatTableViewDelegate: AnyObject {
    func valueChanged(newVal: RepeatOption?)
}

class ListDetailsRepeatTableView: UITableViewController {

    struct TableViewSection {

        enum CellType {
            case never
            case minutely
            case hourly
            case daily
            case weekly
            case monthly
            case yearly
        }

        let rows: [CellType]

        init(rows: [CellType]) {
            self.rows = rows
        }
    }

    fileprivate var sections = [TableViewSection]()

    let viewModel: ListDetailsRepeatTableViewViewModel

    weak var delegate: ListDetailsRepeatTableViewDelegate?

    init(viewModel: ListDetailsRepeatTableViewViewModel) {
        self.viewModel = viewModel
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
        self.title = "Repeat"

        self.navigationItem.backButtonTitle = "back"
    }

    // MARK: tableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.rows.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewHeaderView") as! TableViewHeaderView
        view.viewModel = TableViewHeaderViewViewModel(title: "Repeat")
        return view
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = sections[indexPath.section].rows[indexPath.row]

        switch cellType {
        case .never:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeSelectionTableViewCell", for: indexPath) as! ThemeSelectionTableViewCell
            cell.viewModel = ThemeSelectionTableViewCellViewModel(
                theme: "Never",
                isSelected: self.viewModel.currentList.repeatOption == nil
            )
            return cell
        case .minutely:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeSelectionTableViewCell", for: indexPath) as! ThemeSelectionTableViewCell
            cell.viewModel = ThemeSelectionTableViewCellViewModel(
                theme: "Minutely",
                isSelected: self.viewModel.currentList.repeatOption == .minutely
            )
            return cell
        case .hourly:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeSelectionTableViewCell", for: indexPath) as! ThemeSelectionTableViewCell
            cell.viewModel = ThemeSelectionTableViewCellViewModel(
                theme: "Hourly",
                isSelected: self.viewModel.currentList.repeatOption == .hourly
            )
            return cell
        case .daily:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeSelectionTableViewCell", for: indexPath) as! ThemeSelectionTableViewCell
            cell.viewModel = ThemeSelectionTableViewCellViewModel(
                theme: "Daily",
                isSelected: self.viewModel.currentList.repeatOption == .daily
            )
            return cell
        case .weekly:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeSelectionTableViewCell", for: indexPath) as! ThemeSelectionTableViewCell
            cell.viewModel = ThemeSelectionTableViewCellViewModel(
                theme: "Weekly",
                isSelected: self.viewModel.currentList.repeatOption == .weekly
            )
            return cell
        case .monthly:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeSelectionTableViewCell", for: indexPath) as! ThemeSelectionTableViewCell
            cell.viewModel = ThemeSelectionTableViewCellViewModel(
                theme: "Monthly",
                isSelected: self.viewModel.currentList.repeatOption == .monthly
            )
            return cell
        case .yearly:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeSelectionTableViewCell", for: indexPath) as! ThemeSelectionTableViewCell
            cell.viewModel = ThemeSelectionTableViewCellViewModel(
                theme: "Yearly",
                isSelected: self.viewModel.currentList.repeatOption == .yearly
            )
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = sections[indexPath.section].rows[indexPath.row]

        switch cellType {
        case .never:
            self.viewModel.currentList.repeatOption = nil
        case .minutely:
            self.viewModel.currentList.repeatOption = .minutely
        case .hourly:
            self.viewModel.currentList.repeatOption = .hourly
        case .daily:
            self.viewModel.currentList.repeatOption = .daily
        case .weekly:
            self.viewModel.currentList.repeatOption = .weekly
        case .monthly:
            self.viewModel.currentList.repeatOption = .monthly
        case .yearly:
            self.viewModel.currentList.repeatOption = .yearly
        }
        delegate?.valueChanged(newVal: self.viewModel.currentList.repeatOption)
        configureAndSave()
    }
}

extension ListDetailsRepeatTableView {

    func configureAndSave() {
        self.configureCellTypes()
        self.tableView.reloadData()
    }
}

// MARK: set up methods

extension ListDetailsRepeatTableView {

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
        sections.append(.init(rows: [.never, .minutely, .hourly, .daily, .weekly, .monthly, .yearly]))

        self.sections = sections
    }
}

extension ListDetailsRepeatTableView: Themed {
    func applyTheme(_ theme: AppTheme) {
        self.tableView.backgroundColor = theme.secondaryBackgroundColor
        self.navigationController?.navigationBar.barTintColor = theme.barBackgroundColor
        self.navigationController?.navigationBar.tintColor = theme.tintColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.textColor]
        tableView.reloadData()
    }
}

extension ListDetailsRepeatTableView: FontProtocol {
    func applyFont(_ font: AppFont) {
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: font.mediumFontValue().withSize(17),
            NSAttributedString.Key.foregroundColor: themeProvider.currentTheme.textColor
        ]

        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: font.fontValue().withSize(17),
            NSAttributedString.Key.foregroundColor: self.themeProvider.currentTheme.textColor
        ],
        for: .normal)

        navigationItem.backBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: font.fontValue().withSize(17),
            NSAttributedString.Key.foregroundColor: self.themeProvider.currentTheme.textColor
        ],
        for: .normal)
    }
}


