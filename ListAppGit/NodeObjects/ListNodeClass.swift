//
//  ListNodeClass.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-08-23.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation

class Node: Equatable, Encodable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
    
    var value: String
    var id: UUID
    var children: [Node] = []
    var parent: Node?
    
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
        child.parent = self
    }
    
    func delete() {
        self.parent?.children.removeAll(where: ({ $0 == self }))
    }
}
