//
//  ListTableView.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-08-26.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct ListTableViewModel {
    let currentList: Node
    let rootNode: Node

    init(currentList: Node, rootNode: Node) {
        self.currentList = currentList
        self.rootNode = rootNode
    }
}

class ListTableView: UITableViewController {

    struct TableViewSection {

        enum CellType {
            case addNewListCell
            case listCell
            case pullDownPrompt
        }

        let rows: [CellType]

        init(rows: [CellType]) {
            self.rows = rows
        }
    }

    fileprivate var sections = [TableViewSection]()

    fileprivate var viewModel: ListTableViewModel
    fileprivate var coreList: [NSManagedObject] = []

    var addTop = false
    var baseOffset: CGFloat?
    var firstTime = true

    init(viewModel: ListTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.currentList.value
        self.configureCellTypes()
        self.setUpNavigationControllerBarButtonItem()
        self.setupTableView()
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
        case .addNewListCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "listItemAddCell", for: indexPath) as! ListTableViewAddItemCell
            cell.textField.delegate = self
            return cell
        case .listCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath) as! ListTableViewCell
            cell.viewModel = ListTableViewCellViewModel(list: viewModel.currentList.children[indexPath.row])
            return cell
        case .pullDownPrompt:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PullDownToAddPrompt", for: indexPath) as! PullDownToAddNewListCell
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = sections[indexPath.section].rows[indexPath.row]

        switch cellType {
        case .addNewListCell:
            let cell = tableView.cellForRow(at: indexPath) as? ListTableViewAddItemCell
            cell?.textField.becomeFirstResponder()
        case .listCell:
            let nodeTapped = viewModel.currentList.children[indexPath.row]
            let vm = ListTableViewModel(currentList: nodeTapped, rootNode: viewModel.rootNode)
            let view = ListTableView(viewModel: vm)
            navigationController?.pushViewController(view, animated: true)
        case .pullDownPrompt:
            return
        }
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            self.viewModel.currentList.children[indexPath.row].delete()
            self.saveCoreData(name: listsToStringRoot(list: self.viewModel.rootNode))
            self.configureCellTypes()
            tableView.reloadData()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .clear
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if firstTime {
            firstTime = false
            baseOffset = scrollView.contentOffset.y
        }

        guard let refreshControl = refreshControl, let baseOffset = baseOffset else { return }

        if scrollView.contentOffset.y <= baseOffset - 34 {
            self.tableView.isScrollEnabled = false
            if !refreshControl.isRefreshing {
                refreshControl.beginRefreshing()
                self.AddNewListFromPullDown()
            }
        }
    }
}

extension ListTableView {
    @objc func addButton() {

        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField { textField in
            textField.tintColor = .black
        }


        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            if answer.text! == "" { return }
            let newNode = Node(value: answer.text!)
            self.viewModel.currentList.add(child: newNode)
            self.configureCellTypes()
            self.tableView.reloadData()
            self.saveCoreData(name: listsToStringRoot(list: self.viewModel.rootNode))
        }
        submitAction.setValue(UIColor.black, forKey: "titleTextColor")

        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            return
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")

        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }

    func saveCoreData(name: String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "List", in: managedContext)!
        let List = NSManagedObject(entity: entity, insertInto: managedContext)
        List.setValue(name, forKeyPath: "listString")

        do {
            try managedContext.save()
            coreList.append(List)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func configureAndSave() {
        self.configureCellTypes()
        self.tableView.reloadData()
    }
}

// MARK: set up methods

extension ListTableView {

    func setupTableView() {
        self.tableView.separatorStyle = .none
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "listItemCell")
        tableView.register(ListTableViewAddItemCell.self, forCellReuseIdentifier: "listItemAddCell")
        tableView.register(PullDownToAddNewListCell.self, forCellReuseIdentifier: "PullDownToAddPrompt")

        self.tableView.refreshControl = UIRefreshControl()
        addPullToAddView()
    }

    func pullToAddFirstResponderChange() {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ListTableViewAddItemCell
        cell?.textField.becomeFirstResponder()
    }

    func addPullToAddView() {
        let refreshView = PullToAddView()

        guard let refreshControl  = self.tableView.refreshControl else { return }
        refreshView.frame = refreshControl.frame
        refreshControl.addSubview(refreshView)
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = .white

        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            self.tableView.addSubview(refreshControl)
        }

        NSLayoutConstraint.activate([
            refreshView.textField.bottomAnchor.constraint(equalTo: self.tableView.topAnchor, constant: -8),
        ])
    }


    func AddNewListFromPullDown() {
        self.refreshControl?.endRefreshing()
        self.addTop = true
        self.configureAndSave()
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: false)
        self.pullToAddFirstResponderChange()
        self.addTop = false
    }

    func configureCellTypes() {

        defer { tableView.reloadData() }

        var sections = [TableViewSection]()

        if self.addTop {
            sections.append(.init(rows: [.addNewListCell]))
        }

        var listSection = [TableViewSection.CellType]()

        for _ in viewModel.currentList.children {
            listSection.append(.listCell)
        }
        sections.append(.init(rows: listSection))

        if viewModel.currentList.children.count < 3, !self.addTop {
            sections.append(.init(rows: [.pullDownPrompt]))
        }

        self.sections = sections
    }

    func setUpNavigationControllerBarButtonItem() {
        let rightBarButtonItem: UIBarButtonItem = {
            let bbi = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButton))
            bbi.tintColor = .black
            return bbi
        }()
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

}

// MARK: Text Field Delegate Methods

extension ListTableView: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool { return true }

    func textFieldDidBeginEditing(_ textField: UITextField) { }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { return true }

    func textFieldDidEndEditing(_ textField: UITextField) { }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) { }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { return true }

    func textFieldShouldClear(_ textField: UITextField) -> Bool { return true }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let newText = textField.text, newText != "" {
            self.viewModel.currentList.add(child: Node(value: newText), front: !self.addTop)
            self.saveCoreData(name: listsToStringRoot(list: self.viewModel.rootNode))
            self.configureAndSave()
            self.tableView.isScrollEnabled = true
            textField.text = ""
        } else if let newText = textField.text, newText == "" {
            self.configureAndSave()
            self.tableView.isScrollEnabled = true
        }
        return true
    }

}
