//
//  ListDetailsTableView.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-09-10.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct ListDetailsTableViewModel {
    let currentList: Node

    init(currentList: Node, rootNode: Node) {
        self.currentList = currentList
    }
}

class ListDetailsTableView: UITableViewController {

    struct TableViewSection {

        enum CellType {
            case editNameCell
            case listDepth
            case deadline
            case repetition
        }

        let rows: [CellType]

        init(rows: [CellType]) {
            self.rows = rows
        }
    }

    fileprivate var sections = [TableViewSection]()

    fileprivate var viewModel: ListDetailsTableViewModel
    fileprivate var coreList: [NSManagedObject] = []
    fileprivate var rootNodeNSObject: [NSObject] = []

    fileprivate var showRepeat: Bool


    init(viewModel: ListDetailsTableViewModel) {
        self.viewModel = viewModel
        self.showRepeat = viewModel.currentList.deadline != nil
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setUpTheming()
        setUpFont()
        super.viewDidLoad()
        self.title = "List Details"
        self.configureCellTypes()
        self.setupTableView()
        self.setupNavigation()

    }

    // MARK: tableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 10
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = sections[indexPath.section].rows[indexPath.row]

        switch cellType {
        case .editNameCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListDetailsEditNameTableViewCell", for: indexPath) as! ListDetailsEditNameTableViewCell
            cell.textField.delegate = self
            cell.viewModel = ListDetailsEditNameTableViewCellViewModel(list: viewModel.currentList)
            return cell
        case .listDepth:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListDetailsListDepthTableViewCell", for: indexPath) as! ListDetailsListDepthTableViewCell
            cell.viewModel = ListDetailsListDepthTableViewCellViewModel(list: viewModel.currentList)
            return cell
        case .deadline:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListDetailsDeadlineTableViewCell", for: indexPath) as! ListDetailsDeadlineTableViewCell
            cell.viewModel = ListDetailsDeadlineTableViewCellViewModel(list: viewModel.currentList)
            cell.delegate = self
            return cell
        case .repetition:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewButtonCell", for: indexPath) as! TableViewButtonCell
            let secondaryTitle = self.viewModel.currentList.repeatOption != nil ? self.viewModel.currentList.repeatOption?.rawValue : "Never"
            cell.viewModel = TableViewButtonCellViewModel(title: "Repeat", secondaryTitle: secondaryTitle)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = sections[indexPath.section].rows[indexPath.row]

        switch cellType {
        case .editNameCell:
            return
        case .listDepth:
            return
        case .deadline:
            return
        case .repetition:
            let viewModel = ListDetailsRepeatTableViewViewModel(currentList: self.viewModel.currentList)
            let view = ListDetailsRepeatTableView(viewModel: viewModel)
            view.delegate = self
            navigationController?.pushViewController(view, animated: true)
        }

    }
}

extension ListDetailsTableView {

    func configureAndSave() {
        self.configureCellTypes()
        self.tableView.reloadData()
    }
}

// MARK: set up methods

extension ListDetailsTableView {

    func setupTableView() {
        registerTableViewCells()
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = themeProvider.currentTheme.backgroundColor
    }

    func setupNavigation() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: self.title, style: .plain, target: self, action: #selector(self.back))
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: self.fontProvider.currentFont.fontValue().withSize(17),
            NSAttributedString.Key.foregroundColor: self.themeProvider.currentTheme.textColor
        ],
        for: .normal)

        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: self.fontProvider.currentFont.fontValue().withSize(17),
            NSAttributedString.Key.foregroundColor: self.themeProvider.currentTheme.textColor
        ],
        for: .normal)
    }

    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }

    func registerTableViewCells() {
        tableView.register(ListDetailsEditNameTableViewCell.self, forCellReuseIdentifier: "ListDetailsEditNameTableViewCell")
        tableView.register(ListDetailsListDepthTableViewCell.self, forCellReuseIdentifier: "ListDetailsListDepthTableViewCell")
        tableView.register(ListDetailsDeadlineTableViewCell.self, forCellReuseIdentifier: "ListDetailsDeadlineTableViewCell")
        tableView.register(TableViewButtonCell.self, forCellReuseIdentifier: "TableViewButtonCell")
    }

    func configureCellTypes() {

        defer { tableView.reloadData() }

        var sections = [TableViewSection]()
        sections.append(.init(rows: [.editNameCell]))

        // Potentially useful information for the user but we will leave it out for now
        //sections.append(.init(rows: [.listDepth]))
        sections.append(.init(rows: [.deadline]))

        if self.showRepeat {
            sections.append(.init(rows: [.repetition]))
        }
        
        self.sections = sections
    }
}

extension ListDetailsTableView: NameListDetailsDeadlineTableViewCellDelegate {

    func reloadTableView() {
        configureAndSave()
    }

    func deadlineToggleIsTrue(value: Bool) {
        self.showRepeat = value
    }
}

extension ListDetailsTableView: ListDetailsRepeatTableViewDelegate {
    func valueChanged(newVal: RepeatOption?) {
        self.viewModel.currentList.repeatOption = newVal
        configureAndSave()
    }
}


extension ListDetailsTableView: Themed {
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = theme.backgroundColor
    }
}

extension ListDetailsTableView: FontProtocol {
    func applyFont(_ font: AppFont) {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font.mediumFontValue().withSize(18),
                                                                   NSAttributedString.Key.foregroundColor: themeProvider.currentTheme.textColor]
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

// MARK: Text Field Delegate Methods

extension ListDetailsTableView: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool { return true }

    func textFieldDidBeginEditing(_ textField: UITextField) { }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { return true }

    func textFieldDidEndEditing(_ textField: UITextField) { }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) { }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { return true }

    func textFieldShouldClear(_ textField: UITextField) -> Bool { return true }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let newVal = textField.text else { return true }
        viewModel.currentList.value = newVal
        self.title = newVal
        textField.endEditing(true)
        return true
    }

}
