//
//  FontSelectionTableView.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-10-14.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct FontSelectionTableViewViewModel {

    var currentFontName: String
    var currentFontDescription: String

    init(currentFontName: String, currentFontDescription: String) {
        self.currentFontName = currentFontName
        self.currentFontDescription = currentFontDescription
    }
}

class FontSelectionTableView: UITableViewController {

    var viewModel: FontSelectionTableViewViewModel? {
        didSet { setupViewModel() }
    }

    struct TableViewSection {

        enum CellType {
            case system
            case newYork
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
        super.viewDidLoad()
        self.setupTableView()
        self.configureCellTypes()
        self.registerTableViewCells()
        self.title = "Font"
    }

    // MARK: tableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = sections[indexPath.section].rows[indexPath.row]

        switch cellType {
        case .system:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FontSelectionTableViewCell", for: indexPath) as! FontSelectionTableViewCell
            cell.viewModel = FontSelectionTableViewCellViewModel(title: "System", fontDescription: "SFPro-Regular", isSelected: cellType.toStringDescription == viewModel?.currentFontDescription)
            return cell
        case .newYork:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FontSelectionTableViewCell", for: indexPath) as! FontSelectionTableViewCell
            cell.viewModel = FontSelectionTableViewCellViewModel(title: "New York", fontDescription: "NewYork-Regular", isSelected: cellType.toStringDescription == viewModel?.currentFontDescription)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = sections[indexPath.section].rows[indexPath.row]

        switch cellType {
        case .system:
            self.viewModel?.currentFontDescription = cellType.toStringDescription
            saveCoreData(name: cellType.toStringName, description: cellType.toStringDescription)
            self.tableView.reloadData()
        case .newYork:
            self.viewModel?.currentFontDescription = cellType.toStringDescription
            saveCoreData(name: cellType.toStringName, description: cellType.toStringDescription)
            self.tableView.reloadData()
        }
    }
}

extension FontSelectionTableView.TableViewSection.CellType {
    var toStringDescription: String {
        switch self {
        case .system:
            return "SFPro-Regular"
        case .newYork:
            return "NewYork-Regular"
        }
    }

    var toStringName: String {
        switch self {
        case .system:
            return "System"
        case .newYork:
            return "New York"
        }
    }
}

extension FontSelectionTableView {

    func configureAndSave() {
        self.configureCellTypes()
        self.tableView.reloadData()
    }
}

// MARK: set up methods

extension FontSelectionTableView {

    func setupViewModel() {
        // do something
    }

    func setupTableView() {
        registerTableViewCells()
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UITraitCollection.current.userInterfaceStyle == .dark ? .systemGray6 : .white
    }

    func registerTableViewCells() {
        tableView.register(FontSelectionTableViewCell.self, forCellReuseIdentifier: "FontSelectionTableViewCell")
    }

    func configureCellTypes() {

        defer { tableView.reloadData() }

        var sections = [TableViewSection]()
        sections.append(.init(rows: [.system]))
        sections.append(.init(rows: [.newYork]))

        self.sections = sections
    }

    func saveCoreData(name: String, description: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CurrentFont", in: managedContext)!
        let fontData = NSManagedObject(entity: entity, insertInto: managedContext)
        fontData.setValue(name, forKeyPath: "fontName")
        fontData.setValue(description, forKeyPath: "fontDescription")

        do {
            try managedContext.save()
            //rootNodeNSObject.append(fontData)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

