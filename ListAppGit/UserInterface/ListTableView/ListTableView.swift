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
        }

        let rows: [CellType]

        init(rows: [CellType]) {
            self.rows = rows
        }
    }

    fileprivate var sections = [TableViewSection]()

    fileprivate var viewModel: ListTableViewModel
    fileprivate var coreList: [NSManagedObject] = []

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
        self.setupBackgroundTap()

        self.tableView.separatorStyle = .none
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "listItemCell")
        tableView.register(ListTableViewAddItemCell.self, forCellReuseIdentifier: "listItemAddCell")
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
}

// MARK: set up methods

extension ListTableView {

    func setupBackgroundTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.addGestureRecognizer(tap)
    }

    @objc func tableTapped() {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? ListTableViewAddItemCell
        cell?.textField.becomeFirstResponder()
    }

    func configureCellTypes() {

        defer {
            tableView.reloadData()
        }

        var sections = [TableViewSection]()

        var listSection = [TableViewSection.CellType]()

        for _ in viewModel.currentList.children {
            listSection.append(.listCell)
        }
        sections.append(.init(rows: listSection))
        sections.append(.init(rows: [.addNewListCell]))
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

extension ListTableView: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        print("TextField should begin editing method called")
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        print("TextField did begin editing method called")
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        print("TextField should snd editing method called")
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        print("TextField did end editing method called")
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        print("TextField did end editing with reason method called")
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        print("While entering the characters this method gets called")
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
        print("TextField should clear method called")
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        print("TextField should return method called")
        // may be useful: textField.resignFirstResponder()
        if let newText = textField.text, newText != "" {
            self.viewModel.currentList.add(child: Node(value: newText), front: false)
            self.saveCoreData(name: listsToStringRoot(list: self.viewModel.rootNode))
            self.configureCellTypes()
            self.tableView.reloadData()
            textField.text = ""
        }
        return true
    }

}
