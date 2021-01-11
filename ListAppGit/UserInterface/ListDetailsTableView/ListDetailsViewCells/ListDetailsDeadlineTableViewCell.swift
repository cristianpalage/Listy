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

protocol NameListDetailsDeadlineTableViewCellDelegate: AnyObject {
    func deadlineToggleIsTrue(value: Bool)
    func reloadTableView()
}

class ListDetailsDeadlineTableViewCell: UITableViewCell {

    var hasDeadline: Bool = false

    weak var delegate: NameListDetailsDeadlineTableViewCellDelegate?

    var viewModel: ListDetailsDeadlineTableViewCellViewModel? {
        didSet { setupViewModel() }
    }

    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .dateAndTime
        return datePicker
    }()

    let deadlinePromptLabel: ListyLabel = {
        let label = ListyLabel()
        label.font = label.font.withSize(17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add a deadline"
        return label
    }()

    let deadlineToggle: UISwitch = {
        let toggle = UISwitch()
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
        setUpTheming()
        setUpFont()
        setupDatePicker()

        contentView.addSubview(deadlinePromptLabel)
        contentView.addSubview(datePicker)
        contentView.addSubview(deadlineToggle)


        NSLayoutConstraint.activate([
            deadlinePromptLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            deadlinePromptLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26),
            deadlinePromptLabel.bottomAnchor.constraint(equalTo: datePicker.topAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            deadlineToggle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            deadlineToggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            deadlineToggle.bottomAnchor.constraint(equalTo: datePicker.topAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: deadlinePromptLabel.bottomAnchor, constant: 8),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func setupViewModel() {
        if let deadline = viewModel?.list.deadline {
            datePicker.date = deadline
            deadlineToggle.isOn = true
            self.hasDeadline = true
            self.datePicker.isHidden = false
        } else {
            self.hasDeadline = false
        }
    }

    @objc func dateChanged(_ sender: UIDatePicker) {
        self.viewModel?.list.deadline = sender.date
        clearNotificationForList(list: self.viewModel?.list)
        scheduleNotification(list: self.viewModel?.list)
        delegate?.reloadTableView()
    }

    @objc func toggleChanged(_ sender: UISwitch) {
        delegate?.deadlineToggleIsTrue(value: sender.isOn)

        datePicker.isHidden = !sender.isOn

        if !sender.isOn {
            self.viewModel?.list.deadline = nil
            self.viewModel?.list.repeatOption = nil
            clearNotificationForList(list: self.viewModel?.list)
        }
        delegate?.reloadTableView()

    }

    func setupDatePicker() {
        datePicker.isHidden = !self.hasDeadline
        datePicker.addTarget(self, action: #selector(dateChanged), for: .allEvents)
        deadlineToggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
    }
}

extension ListDetailsDeadlineTableViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        contentView.backgroundColor = theme.backgroundColor
        deadlinePromptLabel.textColor = theme.textColor

        /* This is a terrible solution but it works for now until a custom date picker is implemented
                The inline datepicker is what I prefer stylistically but since the majority of
                UIDatePickers themes and colors are determined by the system theme and cannot be altered,
                if the user wants to use a theme in the app that is different from what they use on device
                then the UIDatePicker is basically unreradable, thus the compact style works better in
                that case. 
         */
        if #available(iOS 14, *) {
            let userTheme = UITraitCollection.current.userInterfaceStyle
            if (userTheme == .dark && theme == .light) || (userTheme == .light && theme == .dark) {
                datePicker.preferredDatePickerStyle = .compact
            } else {
                datePicker.preferredDatePickerStyle = .inline
            }
        }
    }
}

extension ListDetailsDeadlineTableViewCell: FontProtocol {
    func applyFont(_ font: AppFont) {
        deadlinePromptLabel.font = font.fontValue().withSize(deadlinePromptLabel.font.pointSize)
    }
}

