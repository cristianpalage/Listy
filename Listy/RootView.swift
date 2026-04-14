//
//  RootView.swift
//  ListTest
//
//  Created by Cristian Palage on 3/21/26.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<ListItem> { listItem in
        listItem.root
    }) private var rootList: [ListItem]

    @Query private var all: [ListItem]

    var body: some View {
        if let first = rootList.first {
            ListView(list: first)

            // Debug to see all items
//            List {
//                ForEach(all) { item in
//                    Text(item.title)
//                }
//            }
        } else {
            Text("No List")
                .onAppear {
                    withAnimation {
                        if rootList.isEmpty {
                            addRootList()
                        }
                    }
                }
        }
    }
}

extension RootView {
    func addRootList() {
        let root = ListItem(root: true, title: "Root", items: [], orderIndex: 0)
        modelContext.insert(root)
    }
}
