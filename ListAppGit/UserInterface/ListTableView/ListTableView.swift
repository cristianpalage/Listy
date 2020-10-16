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
    fileprivate var settingsViewModel: SettingsTableViewViewModel
    fileprivate var coreList: [NSManagedObject] = []
    fileprivate var rootNodeNSObject: [NSObject] = []

    var addTop = false
    var baseOffset: CGFloat?
    var firstTime = true
    var inputCellAtBottom = false

    init(viewModel: ListTableViewModel, settingsViewModel: SettingsTableViewViewModel) {
        self.viewModel = viewModel
        self.settingsViewModel = settingsViewModel
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
        setUpTheming()
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
            let view = ListTableView(viewModel: vm, settingsViewModel: self.settingsViewModel)
            navigationController?.pushViewController(view, animated: true)
        case .pullDownPrompt:
            return
        }
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            self.viewModel.currentList.children[indexPath.row].delete()
            self.saveCoreData(with: self.viewModel.rootNode)
            self.configureCellTypes()
            tableView.reloadData()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black, renderingMode: .alwaysOriginal)
        deleteAction.backgroundColor = UITraitCollection.current.userInterfaceStyle == .dark ? .black : .white

        let listDetailsAction = UIContextualAction(style: .normal, title: "settings") { (_, _, completionHandler) in
            let vc = ListDetailsTableView(viewModel: ListDetailsTableViewModel(currentList: self.viewModel.currentList.children[indexPath.row], rootNode: self.viewModel.rootNode))
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.barTintColor = UITraitCollection.current.userInterfaceStyle == .dark ? .black : .white
            navController.navigationBar.setValue(true, forKey: "hidesShadow")
            navController.navigationBar.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
            self.navigationController?.title = self.viewModel.currentList.children[indexPath.row].value
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissDetailsVC))
            self.navigationController!.present(navController, animated: true, completion: nil)
            completionHandler(true)
        }
        listDetailsAction.image = UIImage(systemName: "square.and.pencil")?.withTintColor(UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black, renderingMode: .alwaysOriginal)
        listDetailsAction.backgroundColor = UITraitCollection.current.userInterfaceStyle == .dark ? .black : .white
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, listDetailsAction])
        return configuration
    }

    @objc func dismissDetailsVC() {
        self.dismiss(animated: true)
        self.saveAndReload()
    }

    func saveAndReload() {
        self.tableView.reloadData()
        self.saveCoreData(with: self.viewModel.rootNode)
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

        let ac = UIAlertController(title: "Enter the List name", message: nil, preferredStyle: .alert)
        ac.addTextField { textField in
            textField.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
        }


        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            if answer.text! == "" { return }
            self.addListItem(name: answer.text!)
        }
        submitAction.setValue(UITraitCollection.current.userInterfaceStyle == .dark ? UIColor.white : UIColor.black, forKey: "titleTextColor")

        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            return
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")

        ac.addAction(cancelAction)
        ac.addAction(submitAction)
        present(ac, animated: true)
        if let visualEffectView = ac.view.searchVisualEffectsSubview(), UITraitCollection.current.userInterfaceStyle == .dark {
            visualEffectView.effect = UIBlurEffect(style: .dark)
        }
    }

    func addListItem(name: String, top: Bool? = nil) {
        let newNode = Node(value: name)
        if let top = top {
            self.viewModel.currentList.add(child: newNode, front: top)
        } else {
            self.viewModel.currentList.add(child: newNode)
        }

        self.configureCellTypes()
        self.tableView.reloadData()
        self.saveCoreData(with: self.viewModel.rootNode)
    }

    func saveCoreData(with name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
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

    func saveCoreData(with rootNode: Node) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Root", in: managedContext)!
        let listNode = NSManagedObject(entity: entity, insertInto: managedContext)
        listNode.setValue(rootNode.toNSObject(context: managedContext), forKey: "rootNode")

        do {
            try managedContext.save()
            rootNodeNSObject.append(listNode)
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
        registerTableViewCells()
        setupBackgroundTap()
        self.tableView.separatorStyle = .none
        self.tableView.refreshControl = UIRefreshControl()
        addPullToAddView()
    }

    func registerTableViewCells() {
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "listItemCell")
        tableView.register(ListTableViewAddItemCell.self, forCellReuseIdentifier: "listItemAddCell")
        tableView.register(PullDownToAddNewListCell.self, forCellReuseIdentifier: "PullDownToAddPrompt")
    }

    func setupBackgroundTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.addGestureRecognizer(tap)
    }

    @objc func tableTapped() {
        if let _ = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ListTableViewAddItemCell {
            self.inputCellAtBottom = false
        } else {
            self.inputCellAtBottom = true
        }
        self.configureAndSave()
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? ListTableViewAddItemCell
        cell?.textField.becomeFirstResponder()
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
        refreshControl.tintColor = .clear

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

        // Don't wan't this rn, reconsider
        /*if viewModel.currentList.children.count < 3, !self.addTop {
            sections.append(.init(rows: [.pullDownPrompt]))
        }*/

        if self.inputCellAtBottom {
            sections.append(.init(rows: [.addNewListCell]))
        }

        self.sections = sections
    }

    func setUpNavigationControllerBarButtonItem() {
        let rightBarButtonItem: UIBarButtonItem = {
            let bbi = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButton))
            bbi.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
            return bbi
        }()

        if self.viewModel.currentList.parent == nil {
            let leftBarButtonItem: UIBarButtonItem = {
                let bbi = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(openSettings))
                bbi.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
                return bbi
            }()
            navigationItem.leftBarButtonItem = leftBarButtonItem
        }
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    @objc func openSettings() {
        let view = SettingsTableView(viewModel: self.settingsViewModel)
        navigationController?.pushViewController(view, animated: true)
    }

}

// MARK: Text Field Delegate Methods

extension ListTableView: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool { return true }

    func textFieldDidBeginEditing(_ textField: UITextField) { }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { return true }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.inputCellAtBottom = false
        self.configureAndSave()
        self.tableView.isScrollEnabled = true
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.configureAndSave()
        self.tableView.isScrollEnabled = true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { return true }

    func textFieldShouldClear(_ textField: UITextField) -> Bool { return true }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let newText = textField.text, newText != "" {
            addListItem(name: newText, top: !inputCellAtBottom)
            self.inputCellAtBottom = false
            textField.text = ""
        }
        self.configureAndSave()
        self.tableView.isScrollEnabled = true
        return true
    }
}

extension ListTableView: Themed {
    func applyTheme(_ theme: AppTheme) {
        self.tableView.backgroundView?.backgroundColor = theme.backgroundColor
        self.navigationItem.leftBarButtonItem?.tintColor = theme.tintColor
        self.navigationItem.rightBarButtonItem?.tintColor = theme.tintColor
    }
}
