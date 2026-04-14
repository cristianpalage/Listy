//
//  PullRevealTableView.swift
//  ListTest
//
//  Created by Cristian Palage on 3/25/26.
//

import SwiftUI
import UIKit

// MARK: - Table view

class PullRevealTableView: UITableView {

    let hiddenRowHeight: CGFloat
    var onRevealChanged: ((Bool) -> Void)?
    var onTapEmptySpace: (() -> Void)?

    private var revealState: RevealState = .hidden
    private var dragStartedInNormalArea = false
    private var didFireDragTap = false

    private let lightFeedback = UIImpactFeedbackGenerator(style: .light)
    private let mediumFeedback = UIImpactFeedbackGenerator(style: .medium)

    private enum RevealState { case hidden, dragging, revealed }

    init(hiddenRowHeight: CGFloat) {
        self.hiddenRowHeight = hiddenRowHeight
        super.init(frame: .zero, style: .plain)
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = hiddenRowHeight
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        contentInsetAdjustmentBehavior = .never
        contentInset = UIEdgeInsets(top: -hiddenRowHeight, left: 0, bottom: 0, right: 0)
        register(HostingCell.self, forCellReuseIdentifier: "cell")
        keyboardDismissMode = .interactive
        allowsSelection = false
        dragInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: self)
        if indexPathForRow(at: point) == nil {
            if revealState == .revealed {
                hideInputRow()
            } else {
                onTapEmptySpace?()
            }
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    func hideInputRow() {
        setRevealState(.hidden)
        contentInset.top = -hiddenRowHeight
        setContentOffset(CGPoint(x: 0, y: hiddenRowHeight), animated: false)
    }

    // MARK: Scroll state machine

    func handleDragStart(offset: CGFloat) {
        dragStartedInNormalArea = offset > hiddenRowHeight
        didFireDragTap = false
        if revealState == .dragging { revealState = .hidden }
    }

    func handleScroll(offset: CGFloat, isDragging: Bool) {
        switch revealState {
        case .hidden:
            if !dragStartedInNormalArea && isDragging && offset <= 0 {
                revealState = .dragging
                if !didFireDragTap {
                    didFireDragTap = true
                    lightFeedback.impactOccurred()
                }
            }
        case .dragging:
            if !isDragging && offset >= 0 {
                setRevealState(.revealed)
                setContentOffset(.zero, animated: false)
                contentInset.top = 0
                mediumFeedback.impactOccurred()
            }
        case .revealed:
            if offset >= hiddenRowHeight {
                setRevealState(.hidden)
                contentInset.top = -hiddenRowHeight
            }
        }
    }

    private func setRevealState(_ state: RevealState) {
        revealState = state
        onRevealChanged?(state == .revealed)
    }
}

// MARK: - Cell

private class HostingCell: UITableViewCell {
    private var hostingView: UIView?

    func setHostingView(_ view: UIView) {
        guard view !== hostingView else { return }
        hostingView?.removeFromSuperview()
        hostingView = view
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        contentView.addSubview(view)
        let bottom = view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottom.priority = .defaultHigh
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            bottom,
        ])
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .systemBackground
        contentView.clipsToBounds = true
    }

    required init?(coder: NSCoder) { fatalError() }
}

// MARK: - SwiftUI wrapper

struct PullRevealTableViewRepresentable<Row, Content: View>: UIViewRepresentable {
    let rows: [Row]
    @Binding var isInputRevealed: Bool
    var onDelete: ((Int) -> Void)?
    var onMove: ((Int, Int) -> Void)?
    var onNestItem: ((Int, Int) -> Void)?
    var onTapEmptySpace: (() -> Void)?
    var onToggleCrossOut: ((Int) -> Void)?
    var itemRowPredicate: ((Int) -> Bool)?
    @ViewBuilder var content: (Row) -> Content

    func onDeleteRow(perform action: @escaping (Int) -> Void) -> Self {
        var copy = self
        copy.onDelete = action
        return copy
    }

    func onMoveRow(perform action: @escaping (Int, Int) -> Void) -> Self {
        var copy = self
        copy.onMove = action
        return copy
    }

    func onNestItem(perform action: @escaping (Int, Int) -> Void) -> Self {
        var copy = self
        copy.onNestItem = action
        return copy
    }

    func onTapEmptySpace(perform action: @escaping () -> Void) -> Self {
        var copy = self
        copy.onTapEmptySpace = action
        return copy
    }

    func onToggleCrossOut(perform action: @escaping (Int) -> Void) -> Self {
        var copy = self
        copy.onToggleCrossOut = action
        return copy
    }

    func isItemRow(_ predicate: @escaping (Int) -> Bool) -> Self {
        var copy = self
        copy.itemRowPredicate = predicate
        return copy
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> PullRevealTableView {
        let coordinator = context.coordinator
        coordinator.hostingControllers = makeHostingControllers()
        coordinator.sync(
            isInputRevealed: $isInputRevealed,
            onDelete: onDelete,
            onMove: onMove,
            onNestItem: onNestItem,
            onTapEmptySpace: onTapEmptySpace,
            onToggleCrossOut: onToggleCrossOut,
            itemRowPredicate: itemRowPredicate
        )

        let hiddenRowHeight = coordinator.hostingControllers.first.map {
            $0.view.systemLayoutSizeFitting(
                CGSize(width: UIView.layoutFittingExpandedSize.width, height: UIView.layoutFittingCompressedSize.height),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            ).height
        } ?? 0

        let tableView = PullRevealTableView(hiddenRowHeight: hiddenRowHeight)
        tableView.dataSource = coordinator.dataSource
        tableView.delegate = coordinator
        tableView.dragDelegate = coordinator.dragDrop
        tableView.dropDelegate = coordinator.dragDrop
        tableView.onRevealChanged = { revealed in
            DispatchQueue.main.async { coordinator.isInputRevealed?.wrappedValue = revealed }
        }
        tableView.onTapEmptySpace = { [weak coordinator] in
            DispatchQueue.main.async { coordinator?.onTapEmptySpace?() }
        }
        coordinator.tableView = tableView
        return tableView
    }

    func updateUIView(_ uiView: PullRevealTableView, context: Context) {
        let coordinator = context.coordinator
        let previousCount = coordinator.hostingControllers.count
        coordinator.sync(
            isInputRevealed: $isInputRevealed,
            onDelete: onDelete,
            onMove: onMove,
            onNestItem: onNestItem,
            onTapEmptySpace: onTapEmptySpace,
            onToggleCrossOut: onToggleCrossOut,
            itemRowPredicate: itemRowPredicate
        )

        if previousCount == rows.count {
            zip(coordinator.hostingControllers, rows).forEach { hc, row in hc.rootView = content(row) }
        } else {
            coordinator.hostingControllers = makeHostingControllers()
            coordinator.reloadTableView()
        }

        let lastRowIsItem = itemRowPredicate?(rows.count - 1) ?? true
        if rows.count > previousCount && lastRowIsItem {
            uiView.hideInputRow()
        }
    }

    private func makeHostingControllers() -> [UIHostingController<Content>] {
        rows.map { row in
            let hc = UIHostingController(rootView: content(row))
            hc.view.backgroundColor = .clear
            return hc
        }
    }

    // MARK: - Coordinator

    class Coordinator: NSObject, UITableViewDelegate {
        var hostingControllers: [UIHostingController<Content>] = []
        var isInputRevealed: Binding<Bool>?
        var onDelete: ((Int) -> Void)?
        var onMove: ((Int, Int) -> Void)?
        var onNestItem: ((Int, Int) -> Void)?
        var onTapEmptySpace: (() -> Void)?
        var onToggleCrossOut: ((Int) -> Void)?
        var itemRowPredicate: ((Int) -> Bool)?
        weak var tableView: PullRevealTableView?

        lazy var dataSource = DataSource(coordinator: self)
        lazy var dragDrop = DragDrop(coordinator: self)

        private var pendingDeleteIndex: Int?

        func isItemRow(_ indexPath: IndexPath) -> Bool {
            itemRowPredicate?(indexPath.row) ?? (indexPath.row > 0)
        }

        func sync(
            isInputRevealed: Binding<Bool>,
            onDelete: ((Int) -> Void)?,
            onMove: ((Int, Int) -> Void)?,
            onNestItem: ((Int, Int) -> Void)?,
            onTapEmptySpace: (() -> Void)?,
            onToggleCrossOut: ((Int) -> Void)?,
            itemRowPredicate: ((Int) -> Bool)?
        ) {
            self.isInputRevealed = isInputRevealed
            self.onDelete = onDelete
            self.onMove = onMove
            self.onNestItem = onNestItem
            self.onTapEmptySpace = onTapEmptySpace
            self.onToggleCrossOut = onToggleCrossOut
            self.itemRowPredicate = itemRowPredicate
        }

        func setPendingDelete(_ index: Int) { pendingDeleteIndex = index }

        func reloadTableView() {
            guard let tableView else { return }
            if let index = pendingDeleteIndex, hostingControllers.count == tableView.numberOfRows(inSection: 0) - 1 {
                pendingDeleteIndex = nil
                tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .top)
            } else {
                tableView.reloadData()
            }
        }

        // MARK: UITableViewDelegate - Editing

        func tableView(_ tv: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            isItemRow(indexPath)
        }

        func tableView(_ tv: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            guard isItemRow(indexPath) else { return nil }
            let action = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
                self?.onToggleCrossOut?(indexPath.row)
                completion(true)
            }
            action.image = UIImage(systemName: "strikethrough")
            action.backgroundColor = .systemGray
            return UISwipeActionsConfiguration(actions: [action])
        }

        func tableView(_ tv: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposed: IndexPath) -> IndexPath {
            if isItemRow(proposed) { return proposed }
            return IndexPath(row: min(max(proposed.row, 1), sourceIndexPath.row), section: 0)
        }

        // MARK: UITableViewDelegate - Scroll

        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            tableView?.handleDragStart(offset: scrollView.contentOffset.y)
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            tableView?.handleScroll(offset: scrollView.contentOffset.y, isDragging: scrollView.isDragging)
        }
    }

    // MARK: - DataSource

    class DataSource: NSObject, UITableViewDataSource {
        unowned let coordinator: Coordinator

        init(coordinator: Coordinator) { self.coordinator = coordinator }

        func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
            coordinator.hostingControllers.count
        }

        func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tv.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HostingCell
            cell.setHostingView(coordinator.hostingControllers[indexPath.row].view)
            return cell
        }

        func tableView(_ tv: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            coordinator.isItemRow(indexPath)
        }

        func tableView(_ tv: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                coordinator.setPendingDelete(indexPath.row)
                coordinator.onDelete?(indexPath.row)
            }
        }

        func tableView(_ tv: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            coordinator.isItemRow(indexPath)
        }

        func tableView(_ tv: UITableView, moveRowAt source: IndexPath, to destination: IndexPath) {
            let hc = coordinator.hostingControllers.remove(at: source.row)
            coordinator.hostingControllers.insert(hc, at: destination.row)
            coordinator.onMove?(source.row, destination.row)
        }
    }

    // MARK: - Drag & Drop

    class DragDrop: NSObject, UITableViewDragDelegate, UITableViewDropDelegate {
        unowned let coordinator: Coordinator

        init(coordinator: Coordinator) { self.coordinator = coordinator }

        func tableView(_ tv: UITableView, itemsForBeginning session: any UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
            guard coordinator.isItemRow(indexPath) else { return [] }
            let dragItem = UIDragItem(itemProvider: NSItemProvider())
            dragItem.localObject = indexPath
            return [dragItem]
        }

        func tableView(_ tv: UITableView, dropSessionDidUpdate session: any UIDropSession, withDestinationIndexPath dest: IndexPath?) -> UITableViewDropProposal {
            guard let dest, coordinator.isItemRow(dest) else {
                return UITableViewDropProposal(operation: .cancel)
            }

            // Check if dragging onto self
            if let dragItem = session.items.first,
               let sourceIndexPath = dragItem.localObject as? IndexPath,
               sourceIndexPath == dest {
                return UITableViewDropProposal(operation: .cancel)
            }

            // Determine spatial zone: middle 40% = nest, edges = reorder
            let location = session.location(in: tv)
            if let cell = tv.cellForRow(at: dest) {
                let cellFrame = cell.frame
                let relativeY = location.y - cellFrame.origin.y
                let fraction = relativeY / cellFrame.height
                if fraction > 0.3 && fraction < 0.7 {
                    return UITableViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
                }
            }

            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        func tableView(_ tv: UITableView, performDropWith coordinator: any UITableViewDropCoordinator) {
            guard coordinator.proposal.operation == .move,
                  coordinator.proposal.intent == .insertIntoDestinationIndexPath,
                  let destIndexPath = coordinator.destinationIndexPath,
                  let dragItem = coordinator.items.first,
                  let sourceIndexPath = dragItem.dragItem.localObject as? IndexPath else {
                return
            }
            self.coordinator.onNestItem?(sourceIndexPath.row, destIndexPath.row)
        }
    }
}
