//
//  ListDetailsDeadlineTableViewCell.swift
//  ListAppGit
//
//  Created by Cristian Palage on 2020-09-13.
//  Copyright © 2020 Cristian Palage. All rights reserved.
//

import Foundation
import UIKit

struct ListDetailsDeadlineTableViewCellViewModel {
    var list: Node

    init(list: Node) {
        self.list = list
    }
}

class ListDetailsDeadlineTableViewCell: UITableViewCell {

    var hasDeadline: Bool = false

    var viewModel: ListDetailsDeadlineTableViewCellViewModel? {
        didSet { setupViewModel() }
    }

    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .compact
        }
        datePicker.datePickerMode = .dateAndTime
        return datePicker
    }()

    let deadlinePromptLabel: ListyLabel = {
        let label = ListyLabel()
        label.font = label.font.withSize(15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add a deadline"
        return label
    }()

    let deadlineToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .orange
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}


private extension ListDetailsDeadlineTableViewCell {
    func setup() {
        setupDatePicker()
        setupBackground()

        contentView.addSubview(deadlinePromptLabel)
        contentView.addSubview(datePicker)
        contentView.addSubview(deadlineToggle)


        NSLayoutConstraint.activate([
            deadlinePromptLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            deadlinePromptLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            deadlinePromptLabel.bottomAnchor.constraint(equalTo: datePicker.topAnchor, constant: -8),
        ])

        NSLayoutConstraint.activate([
            deadlineToggle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            deadlineToggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            deadlineToggle.bottomAnchor.constraint(equalTo: datePicker.topAnchor, constant: -8),
        ])

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: deadlinePromptLabel.bottomAnchor, constant: 8),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    func setupBackground() {
        contentView.backgroundColor = UITraitCollection.current.userInterfaceStyle == .dark ? .black : .white
    }

    func setupViewModel() {
        if let deadline = viewModel?.list.deadline {
            datePicker.date = deadline
            deadlineToggle.isOn = true
            datePicker.isHidden = false
            self.hasDeadline = true
        } else {
            datePicker.isHidden = true
            self.hasDeadline = false
        }
    }

    @objc func dateChanged(_ sender: UIDatePicker) {
        self.viewModel?.list.deadline = sender.date
        clearNotificationForList(list: self.viewModel?.list)
        scheduleNotification(list: self.viewModel?.list)
    }

    @objc func toggleChanged(_ sender: UISwitch) {
        datePicker.isHidden = !sender.isOn

        if !sender.isOn {
            self.viewModel?.list.deadline = nil
            clearNotificationForList(list: self.viewModel?.list)
        }
    }

    func setupDatePicker() {
        datePicker.isHidden = !self.hasDeadline
        datePicker.addTarget(self, action: #selector(dateChanged), for: .editingDidEnd)
        deadlineToggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
    }
}

