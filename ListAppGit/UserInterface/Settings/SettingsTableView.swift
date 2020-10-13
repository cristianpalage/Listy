//
//  SettingsTableView.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-12.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SettingsTableView: UITableViewController {

    struct TableViewSection {

        enum CellType {
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
        super.viewDidLoad()
        self.setupTableView()
        self.configureCellTypes()
        self.registerTableViewCells()
        self.title = "Settings"
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
        }
    }
}

extension SettingsTableView {

    func configureAndSave() {
        self.configureCellTypes()
        self.tableView.reloadData()
    }
}

// MARK: set up methods

extension SettingsTableView {

    func setupTableView() {
        registerTableViewCells()
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UITraitCollection.current.userInterfaceStyle == .dark ? .black : .white
    }

    func registerTableViewCells() {
    }

    func configureCellTypes() {

        defer { tableView.reloadData() }

        var sections = [TableViewSection]()

        self.sections = sections
    }

}

