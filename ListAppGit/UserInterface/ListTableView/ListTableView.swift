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

    var viewModel: ListTableViewModel
    var coreList: [NSManagedObject] = []

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

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButton))
        self.tableView.separatorStyle = .none

        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "listItemCell")
    }

    // MARK: tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentList.children.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath) as! ListTableViewCell
        cell.textLabel?.text = viewModel.currentList.children[indexPath.row].value
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nodeTapped = viewModel.currentList.children[indexPath.row]
        let vm = ListTableViewModel(currentList: nodeTapped, rootNode: viewModel.rootNode)
        let view = ListTableView(viewModel: vm)
        navigationController?.pushViewController(view, animated: true)
    }
}

extension ListTableView {
    @objc func addButton() {

        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            if answer.text! == "" { return }
            let newNode = Node(value: answer.text!)
            self.viewModel.currentList.add(child: newNode)
            self.tableView.reloadData()
            self.saveCoreData(name: listsToStringRoot(list: self.viewModel.rootNode))
        }

        ac.addAction(submitAction)
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
