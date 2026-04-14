//
//  List.swift
//  ListTest
//
//  Created by Cristian Palage on 3/21/26.
//

import Foundation
import SwiftData

enum ListLocation {
    case prepend
    case append
}

@Model
final class ListItem {
    var root: Bool
    var title: String
    var orderIndex: Int
    var id: UUID
    var crossedOut: Bool

    @Relationship(deleteRule: .cascade, inverse: \ListItem.parent)
    var items: [ListItem]

    var parent: ListItem?

    init(root: Bool, title: String, items: [ListItem], orderIndex: Int) {
        self.root = root
        self.title = title
        self.items = items
        self.orderIndex = orderIndex
        self.id = UUID()
        self.crossedOut = false
    }

    func isDescendant(of ancestor: ListItem) -> Bool {
        if self.id == ancestor.id { return true }
        var current = self.parent
        while let node = current {
            if node.id == ancestor.id { return true }
            current = node.parent
        }
        return false
    }

    func reparent(to newParent: ListItem) {
        parent?.items.removeAll { $0.id == self.id }
        let maxOrder = newParent.items.map(\.orderIndex).max() ?? -1
        self.orderIndex = maxOrder + 1
        newParent.items.append(self)
    }

    func addItem(title: String, location: ListLocation) {
        let orderIndex: Int = {
            guard items.isEmpty == false else {
                return 0
            }

            switch location {
            case .prepend:
                return items.map({ $0.orderIndex }).min()! - 1
            case .append:
                return items.map({ $0.orderIndex }).max()! + 1
            }
        }()

        let item = ListItem(root: false, title: title, items: [], orderIndex: orderIndex)
        items.append(item)
    }
}
