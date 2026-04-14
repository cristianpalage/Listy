//
//  ListView.swift
//  ListTest
//
//  Created by Cristian Palage on 3/21/26.
//

import SwiftUI
import SwiftData

enum ListRow: Hashable, Equatable {
    case input
    case item(ListItem)
    case bottomInput
}

struct ListView: View {
    @Environment(\.modelContext) private var modelContext

    let list: ListItem

    var sortedItems: [ListItem] {
        list.items.sorted { $0.orderIndex < $1.orderIndex }
    }

    @State private var topInputText = ""
    @State private var bottomInputText = ""

    @State private var isInputRevealed = false
    @FocusState private var isTopInputFocused: Bool

    @State private var isBottomInputVisible = false
    @FocusState private var isBottomInputFocused: Bool

    private var rowData: [ListRow] {
        var rows: [ListRow] = [.input]
        rows.append(contentsOf: sortedItems.map { .item($0) })
        if isBottomInputVisible {
            rows.append(.bottomInput)
        }
        return rows
    }

    private var itemRowOffset: Int { 1 } // row 0 is the hidden top input

    var body: some View {
        NavigationStack {
            PullRevealTableViewRepresentable(
                rows: rowData,
                isInputRevealed: $isInputRevealed
            ) { row in
                rowContent(for: row)
            }
            .onDeleteRow { index in
                deleteItem(at: index - itemRowOffset)
            }
            .onMoveRow { from, to in
                moveItem(from: from - itemRowOffset, to: to - itemRowOffset)
            }
            .onNestItem { source, target in
                nestItem(from: source - itemRowOffset, into: target - itemRowOffset)
            }
            .onTapEmptySpace {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                isBottomInputVisible = true
            }
            .onToggleCrossOut { index in
                toggleCrossOut(at: index - itemRowOffset)
            }
            .isItemRow { row in
                row >= itemRowOffset && row < itemRowOffset + sortedItems.count
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(list.title)
                        .font(.system(size: ListStyle.titleFontSize, weight: .semibold))
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .onChange(of: isInputRevealed) { _, revealed in
                isTopInputFocused = revealed
            }
            .onChange(of: isBottomInputVisible) { _, visible in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isBottomInputFocused = visible
                }
            }
            .onChange(of: isBottomInputFocused) { _, focused in
                if !focused {
                    isBottomInputVisible = false
                }
            }
        }
    }

    @ViewBuilder
    private func rowContent(for row: ListRow) -> some View {
        switch row {
        case .input:
            inputRow
        case .item(let item):
            itemRow(for: item)
        case .bottomInput:
            bottomInputRow
        }
    }

    private var inputRow: some View {
        TextField("New Item", text: $topInputText)
            .font(.system(size: ListStyle.fontSize))
            .focused($isTopInputFocused)
            .onSubmit {
                addListItem(title: topInputText, prepend: true)
                topInputText = ""
            }
            .padding(.horizontal, ListStyle.horizontalPadding)
            .rowStyle()
    }

    private var bottomInputRow: some View {
        TextField("New Item", text: $bottomInputText)
            .font(.system(size: ListStyle.fontSize))
            .foregroundStyle(.primary)
            .focused($isBottomInputFocused)
            .onSubmit {
                addListItem(title: bottomInputText, prepend: false)
                bottomInputText = ""
                isBottomInputVisible = false
            }
            .padding(.horizontal, ListStyle.horizontalPadding)
            .rowStyle()
    }

    private func itemRow(for item: ListItem) -> some View {
        NavigationLink {
            ListView(list: item)
        } label: {
            ListItemView(item: item)
        }
        .foregroundStyle(.primary)
        .rowStyle()
    }

    private func addListItem(title: String, prepend: Bool) {
        guard !title.isEmpty else { return }
        list.addItem(title: title, location: prepend ? .prepend : .append)
        try? modelContext.save()
        isTopInputFocused = false
    }

    private func deleteItem(at index: Int) {
        modelContext.delete(sortedItems[index])
        try? modelContext.save()
    }

    private func toggleCrossOut(at index: Int) {
        sortedItems[index].crossedOut.toggle()
        try? modelContext.save()
    }

    private func moveItem(from source: Int, to destination: Int) {
        var items = sortedItems
        let item = items.remove(at: source)
        items.insert(item, at: destination)
        for (index, item) in items.enumerated() {
            item.orderIndex = index
        }
        try? modelContext.save()
    }

    private func nestItem(from source: Int, into target: Int) {
        let items = sortedItems
        guard source >= 0, source < items.count,
              target >= 0, target < items.count,
              source != target else { return }
        let sourceItem = items[source]
        let targetItem = items[target]
        guard !targetItem.isDescendant(of: sourceItem) else { return }
        sourceItem.reparent(to: targetItem)
        try? modelContext.save()
    }
}

private extension View {
    func rowStyle() -> some View {
        self
            .frame(height: ListItemView.height)
            .listRowSeparator(.hidden, edges: .all)
            .listRowInsets(.vertical, 0)
    }
}
