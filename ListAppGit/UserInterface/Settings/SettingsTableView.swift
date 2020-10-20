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
            case theme
            case appIcon
            case email
            case twitter
            case rateInAppStore
            case privacyPolicy
            case about
            case madeBy
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
        self.title = "Settings"
        setupNavigation()


    }

    // MARK: tableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewHeaderView") as! TableViewHeaderView
        var title = ""
        if section == 0 {
            title = "Appearance"
        } else if section == 1 {
            title = "Send Feedback"
        } else if section == 2 {
            title = ""
        }
        view.viewModel = TableViewHeaderViewViewModel(title: title)
       return view
    }

    /*override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.rows.count
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = sections[indexPath.section].rows[indexPath.row]

        switch cellType {
        case .theme:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewButtonCell", for: indexPath) as! TableViewButtonCell
            cell.viewModel = TableViewButtonCellViewModel(title: "Theme")
            return cell
        case .appIcon:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewButtonCell", for: indexPath) as! TableViewButtonCell
            cell.viewModel = TableViewButtonCellViewModel(title: "App Icon")
            return cell
        case .email:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewButtonCell", for: indexPath) as! TableViewButtonCell
            cell.viewModel = TableViewButtonCellViewModel(title: "Email")
            return cell
        case .twitter:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewButtonCell", for: indexPath) as! TableViewButtonCell
            cell.viewModel = TableViewButtonCellViewModel(title: "Twitter")
            return cell
        case .rateInAppStore:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewButtonCell", for: indexPath) as! TableViewButtonCell
            cell.viewModel = TableViewButtonCellViewModel(title: "Rate in App Store")
            return cell
        case .privacyPolicy:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewButtonCell", for: indexPath) as! TableViewButtonCell
            cell.viewModel = TableViewButtonCellViewModel(title: "Privacy Policy")
            return cell
        case .about:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewButtonCell", for: indexPath) as! TableViewButtonCell
            cell.viewModel = TableViewButtonCellViewModel(title: "About")
            return cell
        case .madeBy:
            return tableView.dequeueReusableCell(withIdentifier: "MadeByTableViewCell", for: indexPath) as! MadeByTableViewCell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = sections[indexPath.section].rows[indexPath.row]

        switch cellType {
        case .theme:
            let view = ThemeSelectionTableView()
            navigationController?.pushViewController(view, animated: true)
        case .appIcon:
            return
        case .email:
            openMailLink()
        case .twitter:
            openTwitterAccount()
        case .rateInAppStore:
            return
        case .privacyPolicy:
            let vc = PrivacyPolicyViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .about:
            let vc = AboutViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .madeBy:
            return 
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateFooterViewHeight(for: tableView.tableFooterView)
    }

    func updateFooterViewHeight(for footer: UIView?) {
        guard let footer = footer else { return }
        footer.frame.size.height = footer.systemLayoutSizeFitting(CGSize(width: view.bounds.width, height: 0)).height
    }
}

extension SettingsTableView {

    func configureAndSave() {
        self.configureCellTypes()
        self.tableView.reloadData()
    }

    func openMailLink() {
        let email = "cristianpalage@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }

    func openTwitterAccount() {
        let screenName =  "cristian_palage"
        let appURL = NSURL(string: "twitter://user?screen_name=\(screenName)")!
        let webURL = NSURL(string: "https://twitter.com/\(screenName)")!

        let application = UIApplication.shared

        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            application.open(webURL as URL)
        }
    }
}

// MARK: set up methods

extension SettingsTableView {

    func setupTableView() {
        registerTableViewCells()
        tableView.tableFooterView = MadeByTableViewCell()
        self.tableView.backgroundColor = themeProvider.currentTheme.secondaryBackgroundColor
    }

    func registerTableViewCells() {
        tableView.register(TableViewButtonCell.self, forCellReuseIdentifier: "TableViewButtonCell")
        tableView.register(MadeByTableViewCell.self, forCellReuseIdentifier: "MadeByTableViewCell")
        tableView.register(TableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: "TableViewHeaderView")
    }

    func setupNavigation() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: self.title, style: .plain, target: self, action: #selector(self.back))
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: self.fontProvider.currentFont.fontValue().withSize(17),
            NSAttributedString.Key.foregroundColor: self.themeProvider.currentTheme.textColor
        ],
        for: .normal)
    }


    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }

    func configureCellTypes() {

        defer { tableView.reloadData() }

        var sections = [TableViewSection]()
        sections.append(.init(rows: [.appIcon, .theme]))
        sections.append(.init(rows: [.email, .twitter, .rateInAppStore]))
        sections.append(.init(rows: [.privacyPolicy, .about]))

        self.sections = sections
    }
}

extension SettingsTableView: Themed {
    func applyTheme(_ theme: AppTheme) {
        self.tableView.backgroundColor = theme.secondaryBackgroundColor
        navigationItem.leftBarButtonItem?.tintColor = theme.textColor
        navigationItem.backBarButtonItem?.tintColor = theme.tintColor

        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: fontProvider.currentFont.fontValue().withSize(17),
            NSAttributedString.Key.foregroundColor: theme.textColor
        ],
        for: .normal)
        navigationItem.backBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font: fontProvider.currentFont.fontValue().withSize(17),
            NSAttributedString.Key.foregroundColor: theme.textColor
        ],
        for: .normal)
    }
}

extension SettingsTableView: FontProtocol {
    func applyFont(_ font: AppFont) {
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

        navigationItem.leftBarButtonItem?.tintColor = self.themeProvider.currentTheme.textColor
        navigationItem.backBarButtonItem?.tintColor = self.themeProvider.currentTheme.tintColor
    }
}

