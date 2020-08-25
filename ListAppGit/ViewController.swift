//
//  ViewController.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-08-23.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//


import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet { tableView.separatorStyle = .none }
    }
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var currentNode = Node(value: "Home")
    var rootNode = Node(value: "root")
    var listString: String = ""
    var coreList: [NSManagedObject] = []
    var nodeToDelete = Node(value: "temp")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadListsFromDisk()
        tableView.delegate = self
        tableView.dataSource = self
        listName.text = currentNode.value
        setLists()
        
        tableView.register(TestCell.self, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func backButton(_ sender: Any) {
        guard currentNode.parent != nil else { return }
        listName.text = currentNode.parent?.value
        currentNode = currentNode.parent!
        tableView.reloadData()
    }
    
    
    
    @IBAction func addButton(_ sender: Any) {
        
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            if answer.text! == "" { return }
            let newNode = Node(value: answer.text!)
            self.currentNode.add(child: newNode)
            self.tableView.reloadData()
            self.saveCoreData(name: listsToStringRoot(list: self.rootNode))
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    
    func loadListsFromDisk() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "List")
        do {
            coreList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func setLists() {
        let list = parseToRootNode(list: coreList.last?.value(forKeyPath: "listString") as? String ?? "[Home]")
        currentNode = list
        rootNode = list
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



extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentNode = currentNode.children[indexPath.row]
        listName.text = currentNode.value
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentNode.children.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = currentNode.children[indexPath.row].value
        
        return cell
    }
}

extension ViewController {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            currentNode.children[indexPath.row].delete()
            saveCoreData(name: listsToStringRoot(list: rootNode))
            tableView.reloadData()
        }
    }
}


