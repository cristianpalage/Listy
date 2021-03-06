//
//  ListNodeClass.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-08-23.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum RepeatOption: String, Codable {
    case minutely
    case hourly
    case daily
    case weekly
    case monthly
    case yearly
}

class Node: Equatable, Encodable {
    
    var value: String
    var id: UUID
    var deadline: Date?
    var repeatOption: RepeatOption?
    var children: [Node] = []
    var parent: Node?
    var childrenOrder: String?
    
    init(value: String) {
        self.value = value
        self.id = UUID()
    }
    
    func add(child: Node, front: Bool? = false) {
        if let front = front, front {
            children.insert(child, at: 0)
        } else {
            children.append(child)
        }
        orderString()
        child.parent = self
    }
    
    func delete() {
        self.parent?.children.removeAll(where: ({ $0 == self }))
        clearNotificationForList(list: self, recursive: true)
    }

    func orderString() {
        guard !children.isEmpty else { return }
        var returnString = ""
        for child in children {
            returnString = returnString + child.id.uuidString + ","
        }
        returnString.removeLast()
        childrenOrder = returnString
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Node {
    func toNSObject(context: NSManagedObjectContext) -> NSManagedObject {
        let entity = NSEntityDescription.entity(forEntityName: "ListNode", in: context)!
        let listNode = NSManagedObject(entity: entity, insertInto: context)
        listNode.setValue(value, forKeyPath: "value")
        listNode.setValue(id, forKeyPath: "id")
        listNode.setValue(childrenOrder, forKey: "childrenOrder")
        listNode.setValue(deadline, forKey: "deadline")
        listNode.setValue(repeatOption?.rawValue, forKey: "repeatOption")

        for child in children {
            let children = listNode.mutableSetValue(forKey: "children")
            children.add(child.toNSObject(context: context))
        }
        return listNode
    }

    func depth() -> Int {
        if self.children.isEmpty { return 0 }
        return self.children.map({ $0.depth() }).reduce(self.children.count, +)
    }
}
