//
//  ListService.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-09-02.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import CoreData

func NSobjectNodeToNode(NSObjectNode: NSObject? = nil) -> Node {
    let node = Node(value: "Home")

    node.id = NSObjectNode?.value(forKeyPath: "id") as? UUID ?? UUID()
    node.value = NSObjectNode?.value(forKeyPath: "value") as? String ?? ""
    node.deadline = NSObjectNode?.value(forKeyPath: "deadline") as? Date ?? nil

    let repeatOtionString = NSObjectNode?.value(forKey: "repeatOption") as? String ?? ""

    if repeatOtionString == "minutely" {
        node.repeatOption = .minutely
    } else if repeatOtionString == "hourly" {
        node.repeatOption = .hourly
    } else if repeatOtionString == "daily" {
        node.repeatOption = .daily
    } else if repeatOtionString == "weekly" {
        node.repeatOption = .weekly
    } else if repeatOtionString == "monthly" {
        node.repeatOption = .monthly
    } else if repeatOtionString == "yearly" {
        node.repeatOption = .yearly
    } else {
        node.repeatOption = nil
    }

    // need to do this way as childrenOrder is changed again when children are added
    let order = NSObjectNode?.value(forKeyPath: "childrenOrder") as? String ?? ""
    node.childrenOrder = NSObjectNode?.value(forKeyPath: "childrenOrder") as? String ?? ""

    guard let children = NSObjectNode?.mutableSetValue(forKey: "children") else { return node }

    for child in children {
        node.add(child: NSobjectNodeToNode(NSObjectNode: child as? NSObject))
    }

    node.children = sortByID(children: node.children, identifiers: order)
    node.orderString()

    return node
}

func sortByID(children: [Node], identifiers: String) -> [Node] {
    let ids = getIdArray(ids: identifiers)
    var returnNode = [Node]()

    for id in ids {
        for child in children {
            if child.id.uuidString == id { returnNode.append(child) }
        }
    }

    let existingUUID = returnNode.map({ $0.id })
    for child in children {
        if existingUUID.contains(child.id) {
            continue
        }
        returnNode.append(child)
    }

    return returnNode
}

func getIdArray(ids: String) -> [String] {
    var identifiers: [String] = []

    var tempString:String = ""
    for character in ids {
        if character != "," {
            tempString = tempString + String(character)
        } else {
            identifiers.append(tempString)
            tempString = ""
        }
    }
    identifiers.append(tempString)
    return identifiers
}
